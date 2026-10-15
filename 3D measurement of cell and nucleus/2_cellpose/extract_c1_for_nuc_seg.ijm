



pathname = "D:/hui ting/Group4_YAP_LamAC/data/regions_ch1234/";
list = getFileList(pathname);

res_folder = "D:/hui ting/Group4_YAP_LamAC/data/regions_ch1"
File.makeDirectory(res_folder);

total_files = list.length;

for (ifile = 0; ifile < total_files; ifile++) {

   if (endsWith(list[ifile], ".tif")){

open(pathname+list[ifile]);
run("Duplicate...", "duplicate channels=1-1");
outname = replace(list[ifile], ".tif", "_c1.tif");
saveAs("Tiff", res_folder+File.separator+outname);
run("Close All");

   }
   
}
