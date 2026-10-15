

ch_nuc = 1;

pathname = getDirectory("Select input folder");
list = getFileList(pathname);
total_files = list.length;

res_folder = pathname+"max_c1";
File.makeDirectory(res_folder);

for (ifile = 0; ifile < total_files; ifile++) {

if (endsWith(list[ifile], ".tif")){
	
open(pathname+list[ifile]);
name = list[ifile];
run("Select None");
run("Duplicate...", "title=ch_nuc duplicate channels="+ch_nuc+"-"+ch_nuc);
run("Z Project...", "projection=[Max Intensity]");
run("Enhance Contrast", "saturated=0.35");
outname = replace(name, ".tif", "_max_c1.tif");
saveAs(".tif", res_folder+File.separator+outname);

run("Close All");
run("Collect Garbage");

  }
  
}




