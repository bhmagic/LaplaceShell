function [gradient] = making_p_gradient(final_potential, label_in)

nhood = cat(3, [0 0 0; 0 1 0; 0 0 0], [0 1 0; 1 1 1; 0 1 0], [0 0 0; 0 1 0; 0 0 0]);
image_brain = (label_in == 1);
image_brain_shell_in = (label_in == 3);
image_brain_shell_out = (label_in == 2);
image_boundary_condition = (label_in == 4);

image_boundary_condition = (imdilate(image_brain,nhood) & image_boundary_condition);

final_potential_temp = final_potential + double(image_brain_shell_out).*3 + double(image_brain_shell_in).*1;
final_potential_temp(image_boundary_condition)= nan;

image_cortex_minus_one = image_brain;

% cortex_p_l1 = (image_brain );
% cortex_p_l1_temp = padarray(cortex_p_l1,[1 1 1]);
% cortex_p_l1_temp = image_brain | image_brain_shell_out | image_brain_shell_in | image_boundary_condition;

% image_cortex_minus_one = ~imdilate(~cortex_p_l1_temp,nhood);
% 
% image_cortex_minus_one(1,:,:) = 0;
% image_cortex_minus_one(end,:,:) = 0;
% image_cortex_minus_one(:,1,:) = 0;
% image_cortex_minus_one(:,end,:) = 0;
% image_cortex_minus_one(:,:,1) = 0;
% image_cortex_minus_one(:,:,end) = 0;

% image_cortex_minus_one = image_cortex_minus_one(2:end-1,2:end-1,2:end-1);

minus_one_mesh_size = nnz(image_cortex_minus_one(:));

neibors_for_gradient_cal = zeros(minus_one_mesh_size,6);

minus_one_index = find(image_cortex_minus_one(:));



[m_o_x, m_o_y, m_o_z] =  ind2sub(size(image_cortex_minus_one), minus_one_index);


neibors_for_gradient_cal(:,1) = final_potential_temp(  sub2ind(size(image_cortex_minus_one),m_o_x-1, m_o_y, m_o_z));
neibors_for_gradient_cal(:,2) = final_potential_temp(  sub2ind(size(image_cortex_minus_one),m_o_x+1, m_o_y, m_o_z));
neibors_for_gradient_cal(:,3) = final_potential_temp(  sub2ind(size(image_cortex_minus_one),m_o_x, m_o_y-1, m_o_z));
neibors_for_gradient_cal(:,4) = final_potential_temp(  sub2ind(size(image_cortex_minus_one),m_o_x, m_o_y+1, m_o_z));
neibors_for_gradient_cal(:,5) = final_potential_temp(  sub2ind(size(image_cortex_minus_one),m_o_x, m_o_y, m_o_z-1));
neibors_for_gradient_cal(:,6) = final_potential_temp(  sub2ind(size(image_cortex_minus_one),m_o_x, m_o_y, m_o_z+1));
self_for_gradient_cal = final_potential_temp(minus_one_index);
    
gradient_upper = [neibors_for_gradient_cal(:,2), neibors_for_gradient_cal(:,4), neibors_for_gradient_cal(:,6)]-self_for_gradient_cal;
gradient_lower = [-neibors_for_gradient_cal(:,1), -neibors_for_gradient_cal(:,3), -neibors_for_gradient_cal(:,5)]+self_for_gradient_cal;

% gradient_upper(isinf(gradient_upper(:))) = nan;
% gradient_lower(isinf(gradient_lower(:))) = nan;

gradient = [sum([gradient_upper(:,1), gradient_lower(:,1)],2,'omitnan'),sum([gradient_upper(:,2), gradient_lower(:,2)],2,'omitnan'),sum([gradient_upper(:,3), gradient_lower(:,3)],2,'omitnan')]./2;

gradient_x = zeros(size(image_cortex_minus_one));
gradient_y = zeros(size(image_cortex_minus_one));
gradient_z = zeros(size(image_cortex_minus_one));

gradient_x(minus_one_index) = gradient(:,1);
gradient_y(minus_one_index) = gradient(:,2);
gradient_z(minus_one_index) = gradient(:,3);

% gradient_x(~image_cortex_minus_one) = nan;
% gradient_y(~image_cortex_minus_one) = nan;
% gradient_z(~image_cortex_minus_one) = nan;

gradient = cat(4,gradient_x, gradient_y, gradient_z);
% gradient(isinf(gradient)) = 0;

% save -v7.3 gradients_v2.mat gradient image_cortex_minus_one image_cortex_shell_l1
