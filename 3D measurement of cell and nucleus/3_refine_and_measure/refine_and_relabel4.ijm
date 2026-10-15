

// This macro is to refine and relabel nucleus masks based on cell maskS.
// This macro uses MorphoLibJ_-1.6.4.jar plugin.
//
// Written by hui ting, 3 Sep 2025.


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

min_size_cell_um = 2000;  // um3
min_size_nuc_um = 600;   // um3

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

pathname = getDirectory("Select input folder");

pathname_img = pathname+"regions_ch1";
pathname_cell_mask = pathname+"regions_ch1234"+File.separator+"masks";
pathname_nuc_mask = pathname+"regions_ch1"+File.separator+"masks";

list = getFileList(pathname_cell_mask);
total_files = list.length;

res_folder = pathname+"refine_masks";
File.makeDirectory(res_folder);

for (ifile = 0; ifile < total_files; ifile++) {

    if (endsWith(list[ifile], ".tif")){

filename_cell_mask = list[ifile];
filename_nuc_mask = replace(filename_cell_mask , "_cp_masks.tif", "_c1_cp_masks.tif");
filename_img = replace(filename_cell_mask , "_cp_masks.tif", "_c1.tif");

open(pathname_img+File.separator+filename_img);
getVoxelSize(pxl_sz, pxl_sz, z_step, voxel_unit);
close();

min_size_cell = (min_size_cell_um)/(pxl_sz*pxl_sz*z_step);
min_size_nuc = (min_size_nuc_um)/(pxl_sz*pxl_sz*z_step);

open(pathname_cell_mask+File.separator+filename_cell_mask);
rename("cell");

open(pathname_nuc_mask+File.separator+filename_nuc_mask);
rename("nuc");

selectWindow("cell");
getDimensions(width, height, channels, slices, frames);
run("Remove Border Labels", "left right top bottom");
run("Label Size Filtering", "operation=Greater_Than_Or_Equal size="+min_size_cell);
run("Remap Labels");
rename("label_cell");

setThreshold(1, 65535, "raw");
setOption("BlackBackground", true);
run("Convert to Mask", "background=Dark black create");
run("Divide...", "value=255 stack");

imageCalculator("Multiply create 32-bit stack", "MASK_label_cell","nuc");
rename("nuc_refine");

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

run("Remove Border Labels", "left right top bottom");
run("Label Size Filtering", "operation=Greater_Than_Or_Equal size="+min_size_nuc);
run("Remap Labels");
rename("nuc_refine_clean");

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

run("Intensity Measurements 2D/3D", "input=label_cell labels=nuc_refine_clean mode");
mode_array = Table.getColumn("Mode");
Array.getStatistics(mode_array, min_mode, max_mode, mean_mode, stdDev_mode);

call("inra.ijpb.plugins.LabelToValuePlugin.process", "Table=label_cell-intensity-measurements", "Column=Mode", "Min=0.0", "Max="+max_mode);
run("Assign Measure to Label");
rename("label_nuc");
changeValues(NaN, NaN, 0);
setOption("ScaleConversions", false);
run("16-bit");


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


outname_cell = replace(filename_cell_mask, "_cp_masks.tif", "_cell");
outname_nuc = replace(filename_cell_mask, "_cp_masks.tif", "_nuc");
outname_cyto = replace(filename_cell_mask, "_cp_masks.tif", "_cyto");

selectWindow("label_nuc");
setThreshold(1, 65535, "raw");
setOption("BlackBackground", true);
run("Convert to Mask", "background=Dark black create");
run("Invert", "stack");
run("Divide...", "value=255 stack");
imageCalculator("Multiply create stack", "label_cell","MASK_label_nuc");
rename("label_cyto");

run("glasbey inverted");
setMinAndMax(0, max_mode);
setVoxelSize(pxl_sz, pxl_sz, z_step, "um");
saveAs("Tiff", res_folder+File.separator+outname_cyto);

selectWindow("label_cell");
run("glasbey inverted");
setMinAndMax(0, max_mode);
setVoxelSize(pxl_sz, pxl_sz, z_step, "um");
saveAs("Tiff", res_folder+File.separator+outname_cell);

selectWindow("label_nuc");
run("glasbey inverted");
setMinAndMax(0, max_mode);
setVoxelSize(pxl_sz, pxl_sz, z_step, "um");
saveAs("Tiff", res_folder+File.separator+outname_nuc);

selectWindow("label_cell-intensity-measurements");
run("Close");
run("Close All");


    }
    
    
}






