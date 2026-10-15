# 3D_measurement_of_cell_and_nucleus
ImageJ macros and other scripts for performing 3D segmentation and measurement of cell and nucleus.

For enquiries, please contact:  biejly@nus.edu.sg, martin.kiwanuka@u.nus.edu, mbioht@nus.edu.sg

# Part 1: crop regions of different stiffness 

(1) max_project_c1.ijm

(2) detect_triangles

(3) swap_ch_crop.ijm

# Part 2: cellpose segmentation

(1) extract_c1_for_nuc_seg.ijm 

(2) cellpose 4 (*Commands for running Cellpose in batch*)


# Part 3: refine masks and measurement

(1) refine_and_relabel4.ijm

(2) measure_intensity_nuc_cyto.ijm

(3) remove_cell_without_nuc.m

*measure_volume_intensity2.ijm is for measurement without nucleus. In that case, Part 2(1) and Part 3(1),(2),(3) can be skipped.*


