
name = getTitle();
getDimensions(width, height, channels, slices, frames);
getVoxelSize(pxl_sz, pxl_sz, z_step, pxl_unit);

selectWindow("ds");
run("Analyze Particles...", "size=100000-Infinity pixel show=Masks add"); //150000
roiManager("deselect");
roiManager("Combine");
run("Convex Hull");
roiManager("reset");
run("Fit Rectangle");
getSelectionBounds(bb1_x, bb1_y, bb1_w, bb1_h); // *4

selectWindow("Mask of ds");
run("Select None");
run("Duplicate...", "title=get_h");
run("Invert LUT");
getDimensions(width2, height2, channels2, slices2, frames2);
run("Size...", "width=100 height="+height2+" depth=1 average interpolation=Bilinear");
run("Maximum...", "radius=3"); //3
run("Median...", "radius=3");  //3
run("Options...", "iterations=10 count=1 black pad do=Close");
run("Mean...", "radius=3");    //3
doWand(50, height2/2); //2
run("Fit Rectangle");
getSelectionBounds(bb2_x, bb2_y, bb2_w, bb2_h); // *4

roi_x = bb1_x*4;
roi_y = bb2_y*4;
roi_w = round(10500/pxl_sz);      //roi_w = bb1_w*4;
roi_h = round(810/pxl_sz);        //bb2_h*4;

selectWindow(name);
//makeRectangle(roi_x, roi_y, roi_w, roi_h);
//roiManager("Add");



total_reg = 10;
reg_w = round(roi_w/total_reg);
reg_x = roi_x;

for (r = 1; r <= total_reg; r++) {

selectWindow(name);
makeRectangle(reg_x, roi_y, reg_w, roi_h);
roiManager("Add");
reg_x = reg_x+reg_w;

}
