clear
csv_in = 'Y:\Yongsoo_Kim_Lab_3\STP_processed\2020_optical\20200827_HB_U605_C57J_FITC-fill_M_p56_optical/length_density.csv';
atlas_table = readtable('16bit_allen_csv_20200916.csv');
%  read_ROI_sw(997, atlas_table)



% temp_data = niftiinfo('edited_Reslice of allen_10_anno_16bit_hemisphere.nii');
%  
% temp_data(temp_data == 848) = 0;
% temp_data(temp_data == 117) = 0;
% 
% niftiwrite(temp_data,'temp2.nii');
% 
% temp_data = niftiread('temp3.nii');
% temp_data = single(temp_data) +32768;
% % temp_data(temp_data == 997) = 0;
% niftiwrite(single(temp_data),'temp4.nii');

% temp_data = niftiread('temp4.nii');
% temp_data(temp_data == 997) = 0;
% niftiwrite(single(temp_data),'temp5.nii');
temp_data_og = niftiread('temp4.nii');

temp_data = niftiread('temp5.nii');

% laplace_space = zeros(size(temp_data),'single');
% 
% laplace_space(temp_data ~=0) = 1; %everything
% laplace_space(ismember(temp_data,read_ROI_sw(73, atlas_table))) = 0; %everything
% 
% laplace_space(a_pix_touching_b_26(temp_data,read_ROI_sw(382, atlas_table),read_ROI_sw(726, atlas_table))) = 2;
% 
% all_but_ventricle = setdiff(read_ROI_sw(997, atlas_table),read_ROI_sw(73, atlas_table));
% laplace_space(a_pix_touching_b_26(temp_data,all_but_ventricle,read_ROI_sw(73, atlas_table))) = 3;
% 
% all_but_hpf = setdiff(read_ROI_sw(997, atlas_table),read_ROI_sw(1089, atlas_table));
% all_but_hpf = setdiff(all_but_hpf,read_ROI_sw(1099, atlas_table));
% laplace_space(a_pix_touching_b_26(temp_data,read_ROI_sw(466, atlas_table),all_but_hpf)) = 3;
% 
% 
% 
% hpc_not_dg_not_ca3 = setdiff(read_ROI_sw(1089, atlas_table),read_ROI_sw(726, atlas_table));
% hpc_not_dg_not_ca3 = setdiff(hpc_not_dg_not_ca3,read_ROI_sw(463, atlas_table));
% laplace_space(a_pix_touching_b_26(temp_data, hpc_not_dg_not_ca3 ,read_ROI_sw(726, atlas_table))) = 2;
% 
% 
%  laplace_space(a_pix_touching_b_26(temp_data, read_ROI_sw(623, atlas_table) ,read_ROI_sw(776, atlas_table))) = 3;
% 
%  
%  niftiwrite(laplace_space,'temp6.nii');

% laplace_space = niftiread('temp6.nii');
% hpc_not_dg_not_ca3 = setdiff(read_ROI_sw(997, atlas_table),read_ROI_sw(726, atlas_table));
% hpc_not_dg_not_ca3 = setdiff(hpc_not_dg_not_ca3,read_ROI_sw(463, atlas_table));
% laplace_space(a_pix_touching_b_26(temp_data, read_ROI_sw(726, atlas_table),hpc_not_dg_not_ca3)) = 2;
% niftiwrite(laplace_space,'temp7.nii');

% laplace_space = niftiread('temp7.nii');

% laplace_space(a_pix_touching_b_26(laplace_space,1,0)) = 2;

% niftiwrite(laplace_space,'temp8.nii');


% laplace_space =  niftiwrite('temp7.nii');
%{
laplace_space = niftiread('temp8.nii');

% Surface of TH and HY that touching hip or fronix is consider outside
hip_w_fronix = union(read_ROI_sw(1089, atlas_table),read_ROI_sw(1099, atlas_table));
hip_w_fronix = setdiff(hip_w_fronix,read_ROI_sw(737, atlas_table));
hip_w_fronix = setdiff(hip_w_fronix,19);
hip_w_fronix = setdiff(hip_w_fronix,read_ROI_sw(909, atlas_table));

TH_w_HY = union(read_ROI_sw(549, atlas_table),read_ROI_sw(1097, atlas_table));
TH_w_HY = union(TH_w_HY,read_ROI_sw(967, atlas_table));
TH_w_HY = union(TH_w_HY,1009);
TH_w_HY = union(TH_w_HY,read_ROI_sw(784, atlas_table));
laplace_space(a_pix_touching_b_26(temp_data, TH_w_HY, hip_w_fronix)) = 2;
laplace_space(a_pix_touching_b_26(temp_data, hip_w_fronix, TH_w_HY)) = 2;

% Surface of CC touching fronix or HIP is inside
cc = read_ROI_sw(776, atlas_table);
hip_w_fronix = union(hip_w_fronix,590);
% cc = union(cc,530);
% hip_w_fronix = setdiff(hip_w_fronix,530);

% hip_w_fronix = union(read_ROI_sw(1080, atlas_table),read_ROI_sw(1099, atlas_table));
% hip_w_fronix = setdiff(hip_w_fronix,read_ROI_sw(737, atlas_table));

laplace_space(a_pix_touching_b_26(temp_data, cc, hip_w_fronix)) = 3;

% 623 Cerebral nuclei	CNU touching 776	corpus callosum	cc is inside
laplace_space(a_pix_touching_b_26(temp_data, read_ROI_sw(623, atlas_table) ,530)) = 3;
laplace_space(a_pix_touching_b_26(temp_data_og, read_ROI_sw(623, atlas_table) ,997)) = 3;

% 512	Cerebellum	CB touching 313	Midbrain	MB is outside

laplace_space(a_pix_touching_b_26(temp_data_og, read_ROI_sw(313, atlas_table) ,read_ROI_sw(512, atlas_table))) = 2;
laplace_space(a_pix_touching_b_26(temp_data_og, read_ROI_sw(512, atlas_table) ,read_ROI_sw(313, atlas_table))) = 2;

ind_non_zero = find(laplace_space ~=0);
[~,~,zzz] = ind2sub(size(laplace_space), ind_non_zero ) ;
ind_non_zero = ind_non_zero(zzz==size(laplace_space,3));

laplace_space(ind_non_zero) = 4;

niftiwrite(laplace_space,'temp9.nii');
%}
%{
laplace_space = niftiread('temp9.nii');

% Surface of TH and HY that touching hip or fronix is consider outside
hip_w_fronix = union(read_ROI_sw(423, atlas_table),read_ROI_sw(1099, atlas_table));
hip_w_fronix = setdiff(hip_w_fronix,read_ROI_sw(737, atlas_table));
hip_w_fronix = setdiff(hip_w_fronix,19);
hip_w_fronix = setdiff(hip_w_fronix,read_ROI_sw(909, atlas_table));
% hip_w_fronix = setdiff(hip_w_fronix,449);

TH_w_HY = union(read_ROI_sw(549, atlas_table),read_ROI_sw(1097, atlas_table));
TH_w_HY = union(TH_w_HY,read_ROI_sw(967, atlas_table));
TH_w_HY = union(TH_w_HY,1009);
TH_w_HY = union(TH_w_HY,read_ROI_sw(784, atlas_table));
TH_w_HY = union(TH_w_HY,997);

laplace_space(a_pix_touching_b_26(temp_data_og, hip_w_fronix, TH_w_HY)) = 3;



fimbria = [603];

everything_not_hip = setdiff(read_ROI_sw(997, atlas_table), hip_w_fronix);
laplace_space(a_pix_touching_b_26(temp_data_og, fimbria, everything_not_hip)) = 3;
% laplace_space(a_pix_touching_b_26(temp_data, everything_not_hip, fimbria)) = 3;



hip_com = [449];

everything_not_hip = setdiff(read_ROI_sw(997, atlas_table), hip_w_fronix);
laplace_space(a_pix_touching_b_26(temp_data, hip_com, everything_not_hip)) = 3;
laplace_space(a_pix_touching_b_26(temp_data_og, hip_com, 997)) = 2;
% laplace_space(a_pix_touching_b_26(temp_data, everything_not_hip, fimbria)) = 3;


niftiwrite(laplace_space,'temp10.nii');
%}

%{
laplace_space = niftiread('temp10.nii');
laplace_space(a_pix_touching_b_26(temp_data, 672, [952 20046 703])) = 3;
laplace_space(a_pix_touching_b_26(temp_data, [803 477 403], 0)) = 2;


niftiwrite(laplace_space,'temp11.nii');
%}

laplace_space = niftiread('temp11.nii');
% laplace_space(a_pix_touching_b_26(temp_data, 754, 0)) = 2;
% laplace_space(a_pix_touching_b_26(temp_data, [672 477 131 303], [884])) = 2;
ind_non_zero = find(laplace_space ~=0);
[~,~,zzz] = ind2sub(size(laplace_space), ind_non_zero ) ;
ind_non_zero = ind_non_zero(zzz==size(laplace_space,3));
laplace_space(ind_non_zero) = 4;


niftiwrite(laplace_space,'temp12.nii');



% 1 brain
% 2 outside surface  (end)
% 3 ventricle surface  (begin)
% 4 no flux


% relevent fields
% 997 rot
% 73	ventricular systems	VS

% 776	corpus callosum	cc

% 623	Cerebral nuclei	CNU


% 1080	Hippocampal region	HIP
% 726 DG
% 463 CA3
% 382	Field CA1	CA1
% 423	Field CA2	CA2

% 603	fimbria	fi
% 1099	fornix system	fxs
% 466	alveus	alv


% 549	Thalamus	TH
% 1097	Hypothalamus	HY



% 512	Cerebellum	CB
% 313	Midbrain	MB





