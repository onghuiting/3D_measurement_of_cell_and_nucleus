

// This macro measures cell volume, sphericity, position and intensity.
//
// Written by hui ting, 1 Sep 2025.


/////////////////////////////////////////////////////////////////////////////////////////////////////

min_size_um = 2000;  // um3
bg_value = 100;      // To be subtracted from channel 3 and channel 4

/////////////////////////////////////////////////////////////////////////////////////////////////////


img_path = getDirectory("Select your input folder");;
label_path = img_path+"masks";

list = getFileList(img_path);
total_files = list.length;

res_folder = img_path+"Results";
File.makeDirectory(res_folder);

for (ifile = 0; ifile < total_files; ifile++) {
	
	if (endsWith(list[ifile], ".tif")){
	
img_name = list[ifile];
label_name = replace(list[ifile], ".tif", "_cp_masks.tif");

open(img_path+img_name);
rename(img_name);
getVoxelSize(pxl_sz, pxl_sz, z_step, voxel_unit);
min_size = (min_size_um)/(pxl_sz*pxl_sz*z_step);

open(label_path+File.separator+label_name);
rename(label_name);

selectImage(label_name);
getDimensions(width, height, channels, slices, frames);
run("Remove Border Labels", "left right top bottom");
run("Label Size Filtering", "operation=Greater_Than_Or_Equal size="+min_size);
run("Remap Labels");
run("glasbey inverted");
setSlice(round(slices/3));
run("Enhance Contrast", "saturated=0.35");
setVoxelSize(pxl_sz, pxl_sz, z_step, "um");
rename("label_new");

run("Analyze Regions 3D", "voxel_count volume surface_area sphericity centroid surface_area_method=[Crofton (13 dirs.)] euler_connectivity=6");
table_title=Table.title;

selectImage(img_name);
run("Split Channels");

for (ch = 3; ch <= 4; ch++) {

ch_name = "C"+ch+"-"+img_name;
selectImage(ch_name);
run("Subtract...", "value="+bg_value+" stack");

run("Intensity Measurements 2D/3D", "input="+ch_name+" labels=label_new mean stddev");
mean_int=Table.getColumn("Mean");
std_int=Table.getColumn("StdDev");
run("Close");

selectWindow(table_title);
Table.setColumn("Mean_intensity_ch"+ch, mean_int);
Table.setColumn("Stddev_intensity_ch"+ch, std_int);
Table.update;

mean_int = newArray(0);
std_int = newArray(0);

}

selectWindow(table_title);
outname_csv = replace(img_name, ".tif", ".csv");
saveAs("Results", res_folder+File.separator+outname_csv);
run("Close");

selectWindow("label_new");
outname = replace(img_name, ".tif", "_label.tif");
saveAs("Tiff", res_folder+File.separator+outname);
run("Close All");


	}
	
	
}








