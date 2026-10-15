

close all;clear all;clc;

pathname = uigetdir("Select input folder");

files = dir(fullfile(pathname,'*.csv'));
total_files = length(files);

res_folder = pathname+"_final";
mkdir(res_folder);


for ifile = 1:total_files

filename = files(ifile).name

% Read Excel file
T = readtable(fullfile(pathname,filename));
headers = T.Properties.VariableNames;

% Create new empty table with same headers
Tnew = array2table(nan(height(T), width(T)),'VariableNames', headers);

labels = T.Label;
labels_nuc = T.Label_nuc(~isnan(T.Label_nuc));

% Find labels in "label" that do not appear in "label_nuc"
missing_labels = setdiff(labels, labels_nuc);

% Rows to remove
rowsToRemove = ismember(labels, missing_labels);

for i = 1:width(T)
    current_column = T.(i);
    current_column=current_column(~isnan(current_column));

    if length(current_column) == length(labels)
        % Safe to remove from this column
        current_column(rowsToRemove)=[];        
    end
    Tnew.(i)(1:length(current_column))=current_column;
end

outname = replace(filename,'.csv','_matched.xlsx');
writetable(Tnew, fullfile(res_folder, outname));


clearvars -except ifile total_files pathname files res_folder


end