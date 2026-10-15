

// This macro measures intensity inside nucleus and intensity inside cytoplasm.
// It also outputs volume, sphericity, position of nucleus and cell.
// This macro uses MorphoLibJ_-1.6.4.jar plugin.
//
// Written by hui ting, 1 Sep 2025.


/////////////////////////////////////////////////////////////////////////////////////////////////////

bg_value = 100;      // To be subtracted from all channels

/////////////////////////////////////////////////////////////////////////////////////////////////////

pathname = getDirectory("Select your input folder");

img_path = pathname+"regions_ch1234";
label_path = pathname+"refine_masks";

list = getFileList(img_path);
total_files = list.length;

res_folder = pathname+"Results";
File.makeDirectory(res_folder);


for (ifile = 0; ifile < total_files; ifile++) {
	
	if (endsWith(list[ifile], ".tif")){
	
img_name = list[ifile];
cell_label_name = replace(list[ifile], ".tif", "_cell.tif");
cyto_label_name = replace(list[ifile], ".tif", "_cyto.tif");
nuc_label_name = replace(list[ifile], ".tif", "_nuc.tif");

open(img_path+File.separator+img_name);
rename(img_name);
getVoxelSize(pxl_sz, pxl_sz, z_step, voxel_unit);

open(label_path+File.separator+cyto_label_name);
rename("cyto_label");
setVoxelSize(pxl_sz, pxl_sz, z_step, "um");

open(label_path+File.separator+cell_label_name);
rename("cell_label");
setVoxelSize(pxl_sz, pxl_sz, z_step, "um");

open(label_path+File.separator+nuc_label_name);
rename("nuc_label");
setVoxelSize(pxl_sz, pxl_sz, z_step, "um");

selectWindow("nuc_label");
run("Analyze Regions 3D", "voxel_count volume surface_area sphericity centroid surface_area_method=[Crofton (13 dirs.)] euler_connectivity=6");
Label_nuc =  Table.getColumn("Label");
VoxelCount_nuc = Table.getColumn("VoxelCount");
Volume_nuc = Table.getColumn("Volume");
SurfaceArea_nuc = Table.getColumn("SurfaceArea");	
Sphericity_nuc = Table.getColumn("Sphericity");	
CentroidX_nuc = Table.getColumn("Centroid.X");	
CentroidY_nuc = Table.getColumn("Centroid.Y");	
CentroidZ_nuc = Table.getColumn("Centroid.Z");	
selectWindow("nuc_label-morpho");
run("Close");

selectWindow("cell_label");
run("Analyze Regions 3D", "voxel_count volume surface_area sphericity centroid surface_area_method=[Crofton (13 dirs.)] euler_connectivity=6");
table_title_cell=Table.title;

selectWindow(table_title_cell);
Table.setColumn("Label_nuc", Label_nuc);
Table.setColumn("VoxelCount_nuc", VoxelCount_nuc);
Table.setColumn("Volume_nuc", Volume_nuc);
Table.setColumn("SurfaceArea_nuc", SurfaceArea_nuc);
Table.setColumn("Sphericity_nuc", Sphericity_nuc);
Table.setColumn("Centroid.X_nuc", CentroidX_nuc);
Table.setColumn("Centroid.Y_nuc", CentroidY_nuc);
Table.setColumn("Centroid.Z_nuc", CentroidZ_nuc);
Table.update;

selectImage(img_name);
run("Split Channels");

for (ch = 1; ch <= 4; ch++) {

ch_name = "C"+ch+"-"+img_name;
selectImage(ch_name);
run("Subtract...", "value="+bg_value+" stack");

run("Intensity Measurements 2D/3D", "input="+ch_name+" labels=cyto_label mean stddev");
mean_int_cyto=Table.getColumn("Mean");
std_int_cyto=Table.getColumn("StdDev");
run("Close");

run("Intensity Measurements 2D/3D", "input="+ch_name+" labels=nuc_label mean stddev");
mean_int_nuc=Table.getColumn("Mean");
std_int_nuc=Table.getColumn("StdDev");
run("Close");

selectWindow(table_title_cell);
Table.setColumn("Mean_intensity_cyto_ch"+ch, mean_int_cyto);
Table.setColumn("Stddev_intensity_cyto_ch"+ch, std_int_cyto);
Table.setColumn("Mean_intensity_nuc_ch"+ch, mean_int_nuc);
Table.setColumn("Stddev_intensity_nuc_ch"+ch, std_int_nuc);
Table.update;

mean_int_cyto = newArray(0);
std_int_cyto = newArray(0);
mean_int_nuc = newArray(0);
std_int_nuc = newArray(0);

}

selectWindow(table_title_cell);
outname_csv = replace(img_name, ".tif", ".csv");
saveAs("Results", res_folder+File.separator+outname_csv);
run("Close");
run("Close All");


	}
	
	
}








