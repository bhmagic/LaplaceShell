function [S,RHS,cnete_pixr] = creating_laplace_equation_set(label_in)

image_brain = (label_in == 1);
image_brain_shell_in = (label_in == 3);
image_brain_shell_out = (label_in == 2);
image_boundary_condition = (label_in == 4);

mesh_size = nnz(image_brain(:));

cnete_pixr =  find(image_brain(:));

[center_x, center_y, center_z] = ind2sub(size(image_brain), cnete_pixr);

nbhood = zeros(mesh_size, 6, 'uint64');

nbhood(:,1) = sub2ind(size(image_brain), center_x-1, center_y, center_z);
nbhood(:,2) = sub2ind(size(image_brain), center_x+1, center_y, center_z);
nbhood(:,3) = sub2ind(size(image_brain), center_x, center_y-1, center_z);
nbhood(:,4) = sub2ind(size(image_brain), center_x, center_y+1, center_z);
nbhood(:,5) = sub2ind(size(image_brain), center_x, center_y, center_z-1);
nbhood(:,6) = sub2ind(size(image_brain), center_x, center_y, center_z+1);


l1_pixel = find(image_brain_shell_out(:));
l6b_pixel = find(image_brain_shell_in(:));
mid_pixel = find(image_boundary_condition(:));



is_it_l1 = ismember(nbhood, l1_pixel);
l1_sum = sum(double(is_it_l1),2);

is_it_l6b = ismember(nbhood, l6b_pixel);
l6_sum = sum(double(is_it_l6b),2);

RHS = l6_sum - l1_sum;


is_it_mid = ismember(nbhood, mid_pixel);

mid_sum = sum(double(is_it_mid),2);


[logi, loca] = ismember(nbhood,cnete_pixr);


%S = sparse(mesh_size,mesh_size);

%self_loc = sub2ind(size(S),  , );


basic_list = (1:1:mesh_size)';
ones_list = ones(size(basic_list));

ind_1 = basic_list;
ind_2 = basic_list;
ind_v = ones(size(ind_1)).*-6;

ind_v = ind_v + mid_sum;


for ii = 1:1:6
    ind_1 = [ind_1; basic_list(logi(:,ii))];
    ind_2 = [ind_2; loca(logi(:,ii),ii)];
    ind_v = [ind_v; ones_list(logi(:,ii))];
    
end

S = sparse(ind_1,ind_2,ind_v,mesh_size,mesh_size);


