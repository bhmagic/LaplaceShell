clear
close all





% 
% tif_in = 'kind_of_fixed_e13.tif' ;
% % mat_out = 'T_E13-5_LSFM_3SyN10_template0_v3_Symmetric.mat' ;
% 
% 
% 
% label_in = FastTiff(tif_in);

csv_name = '16bit_allen_csv_20200916.csv';


index_id = 1;
index_parent_id = 8;
index_name = 2;
index_acronym = 3;
index_structure_order = 7;





T = readtable(csv_name);

ROI_table.id = table2array(T(:,index_id));
ROI_table.parent = table2array(T(:,index_parent_id));

ROI_table.idx = find(ROI_table.id);
[~,ROI_table.p_idx]=ismember(ROI_table.parent,ROI_table.id);
ROI_table.name = table2array(T(:,index_name));
ROI_table.acronym = table2array(T(:, index_acronym));
ROI_table.structure_order = table2array(T(:, index_structure_order));

G = digraph(ROI_table.p_idx(2:end), ROI_table.idx(2:end), 1, ROI_table.name);


for NNN = 1:length(ROI_table.idx)
    
    list_of_all_ROI_inside{NNN} = find(~isinf(distances(G,NNN)));
    
end


find(ROI_table.idx == )