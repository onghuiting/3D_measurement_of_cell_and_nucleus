

//rearrange = "1342";  // Group 1
//rearrange = "1243";    // Group 2 and Group 3
rearrange = "1234";  // Group 4

pathname = getDirectory("Select input folder");
pathname_roi = pathname+"max_c1";

list = getFileList(pathname);
total_files = list.length;

res_folder = pathname+"regions_ch"+rearrange;
File.makeDirectory(res_folder);

for (ifile = 0; ifile < total_files; ifile++) {

if (endsWith(list[ifile], ".tif")){

roiManager("reset");
open(pathname+list[ifile]);
name = list[ifile];
rename(name);
getDimensions(width, height, channels, slices, frames);
//run("Arrange Channels...", "new="+rearrange);

selectWindow(name);
Stack.setSlice(round(slices/2));

for (ch = 1; ch <= channels; ch++) {
Stack.setChannel(ch);
run("Enhance Contrast", "saturated=0.35");
}

roi_name = replace(list[ifile], ".tif", "_max_c1.zip");
roiManager("Open", pathname_roi+File.separator+roi_name);

total_roi = roiManager("count");

for (c = 0; c < total_roi ; c++) {

selectWindow(name);
roiManager("Select", c);
count = c+1;
run("Duplicate...", "title=R"+count+" duplicate");
outname = replace(name, ".tif", "_R"+count+".tif");
saveAs("Tiff", res_folder+File.separator+outname);
close();
}

run("Close All");
run("Collect Garbage");

  }
  
}




