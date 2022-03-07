function [gradient] = fixing_p_gradient(gradient, label_in)

% clear
% close all
% load 2021_1022_2.mat


image_brain = (label_in == 1);
image_brain_shell_in = (label_in == -2);
image_brain_shell_out = (label_in == -3);
image_boundary_condition = (label_in == -1);


init_ind = find(image_brain);


gradient_xxx = gradient(:,:,:,1);
gradient_yyy = gradient(:,:,:,2);
gradient_zzz = gradient(:,:,:,3);


should_have_value = [gradient_xxx(init_ind),gradient_yyy(init_ind),gradient_zzz(init_ind)];
should_have_value = rms(should_have_value,2);

bad_ind = init_ind(should_have_value == 0);


[xxx_image_brain_shell_in, yyy_image_brain_shell_in, zzz_image_brain_shell_in] = ind2sub(size(image_brain_shell_in),find(image_brain_shell_in));
[xxx_image_brain_shell_out, yyy_image_brain_shell_out, zzz_image_brain_shell_out] = ind2sub(size(image_brain_shell_out),find(image_brain_shell_out));
[xxx_image_boundary_condition, yyy_image_boundary_condition, zzz_image_boundary_condition] = ind2sub(size(image_boundary_condition),find(image_boundary_condition));

xyz_image_brain_shell_in = [xxx_image_brain_shell_in, yyy_image_brain_shell_in, zzz_image_brain_shell_in];
xyz_image_brain_shell_out = [xxx_image_brain_shell_out, yyy_image_brain_shell_out, zzz_image_brain_shell_out];
xyz_image_boundary_condition = [xxx_image_boundary_condition, yyy_image_boundary_condition, zzz_image_boundary_condition];


for ii = 1:length(bad_ind)
    
    [xxx_bad_ind, yyy_bad_ind, zzz_bad_ind] = ind2sub(size(image_brain_shell_in),bad_ind(ii));
    xyz_bad_ind = [xxx_bad_ind, yyy_bad_ind, zzz_bad_ind];
    
    xyz_image_brain_shell_in_s = xyz_image_brain_shell_in-xyz_bad_ind;
    xyz_image_brain_shell_in_rssq = rssq(xyz_image_brain_shell_in_s,2);
    [shell_in_dis, shell_in_ind] = min(xyz_image_brain_shell_in_rssq);
    
    xyz_image_brain_shell_out_s = xyz_image_brain_shell_out-xyz_bad_ind;
    xyz_image_brain_shell_out_rssq = rssq(xyz_image_brain_shell_out_s,2);
    [shell_out_dis, shell_out_ind] = min(xyz_image_brain_shell_out_rssq);
    
    xyz_image_boundary_condition_s = xyz_image_boundary_condition-xyz_bad_ind;
    xyz_image_boundary_condition_rssq = rssq(xyz_image_boundary_condition_s,2);
    [shell_bc_dis, shell_bc_ind] = min(xyz_image_boundary_condition_rssq);
    
    [min_dis, min_cata] = min([shell_in_dis, shell_out_dis, shell_bc_dis]);
    
    switch min_cata
        case 1
            gradient(xxx_bad_ind, yyy_bad_ind, zzz_bad_ind, :) = -xyz_image_brain_shell_in_s(shell_in_ind,:)./xyz_image_brain_shell_in_rssq(shell_in_ind);
        case 2
            gradient(xxx_bad_ind, yyy_bad_ind, zzz_bad_ind, :) = xyz_image_brain_shell_out_s(shell_out_ind,:)./xyz_image_brain_shell_out_rssq(shell_out_ind);
        case 3
            gradient(xxx_bad_ind, yyy_bad_ind, zzz_bad_ind, :) = -xyz_image_boundary_condition_s(shell_bc_ind,:)./xyz_image_boundary_condition_rssq(shell_bc_ind);
    end
    
end


