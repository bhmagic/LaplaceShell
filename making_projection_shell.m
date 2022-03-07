function [init_ind, finn_ind] = making_projection_shell(gradient, label_in)
max_step = 20000;
stepping = 0.25;


image_brain = (label_in == 1);

image_brain_shell_out = (label_in == 2);

image_cortex_plus_o_one = image_brain | image_brain_shell_out;

init_ind = find(image_cortex_plus_o_one);

% nhood = cat(3, [0 0 0; 0 1 0; 0 0 0], [0 1 0; 1 1 1; 0 1 0], [0 0 0; 0 1 0; 0 0 0]);
% almost_there_ind = find(imdilate(image_brain_shell_out,nhood) & image_brain);

% shooting_wrong = find(~image_cortex_plus_o_one);


brain_ind = find( image_brain);

image_size = size(image_brain);

[init_x, init_y, init_z] = ind2sub(image_size, init_ind);
% [shell_x, shell_y, shell_z] = ind2sub(image_size, find(image_brain_shell_out));
% xyz_s = [shell_x, shell_y, shell_z];

gradient_xxx = gradient(:,:,:,1);
gradient_yyy = gradient(:,:,:,2);
gradient_zzz = gradient(:,:,:,3);

clear gradient


gradient_xxx(isnan(gradient_xxx)) = 0;
gradient_yyy(isnan(gradient_yyy)) = 0;
gradient_zzz(isnan(gradient_zzz)) = 0;



current_x = init_x;
current_y = init_y;
current_z = init_z;



still_moving_count = inf;

xxx = round(current_x);
yyy = round(current_y);
zzz = round(current_z);

indexess = sub2ind(image_size,xxx,yyy,zzz);

flaggg_brain = ismember(indexess,brain_ind);
flaggg_brain = find(flaggg_brain);

current_x_flaggg_brain = current_x(flaggg_brain) ;
current_y_flaggg_brain = current_y(flaggg_brain) ;
current_z_flaggg_brain = current_z(flaggg_brain) ;

tot_pix = length(flaggg_brain);
f = waitbar(1,'Please wait...');


for ii = 1:max_step
    
    if still_moving_count ~=0
        
        xxx = round(current_x_flaggg_brain);
        yyy = round(current_y_flaggg_brain);
        zzz = round(current_z_flaggg_brain);
        
        indexess = sub2ind(image_size,xxx,yyy,zzz);
        
        flaggg_temp = ismember(indexess,brain_ind);
        flaggg_brain(~flaggg_temp) = [];
        indexess(~flaggg_temp) = [];
        
        gradient_xxx_c = gradient_xxx(indexess);
        gradient_yyy_c = gradient_yyy(indexess);
        gradient_zzz_c = gradient_zzz(indexess);
        
        length_gradient = sqrt(gradient_xxx_c.*gradient_xxx_c + gradient_yyy_c.*gradient_yyy_c + gradient_zzz_c.*gradient_zzz_c);
        gradient_xxx_c = gradient_xxx_c.*stepping./length_gradient;
        gradient_yyy_c = gradient_yyy_c.*stepping./length_gradient;
        gradient_zzz_c = gradient_zzz_c.*stepping./length_gradient;
        
        gradient_xxx_c(isnan(gradient_xxx_c)|isinf(gradient_xxx_c)) = 0;
        gradient_yyy_c(isnan(gradient_yyy_c)|isinf(gradient_yyy_c)) = 0;
        gradient_zzz_c(isnan(gradient_zzz_c)|isinf(gradient_zzz_c)) = 0;
        
        %%% fixing_cutting_cornner%{
%         flaggg = ismember(indexess,almost_there_ind);
%         if ~isempty(find(flaggg,1))
%             gradient_flagg_c = [gradient_xxx_c(flaggg), gradient_yyy_c(flaggg), gradient_zzz_c(flaggg)] ;
%             current_x_flagg_c = [current_x(flaggg), current_y(flaggg), current_z(flaggg)] + 0.5 ;
%             
%             signage_gradd_flagg = -gradient_flagg_c./abs(gradient_flagg_c);
%             
%             current_x_flagg_c = current_x_flagg_c.*signage_gradd_flagg;
%             current_x_flagg_c = mod(current_x_flagg_c, 1);
%             gradient_flagg_c = current_x_flagg_c./abs(gradient_flagg_c);
%             
%             [~, gradient_flagg_c] = min(gradient_flagg_c,[],2);
%             gradient_flagg_c = sub2ind(size(signage_gradd_flagg),find(gradient_flagg_c),gradient_flagg_c);
%             gradient_flagg_c_2 = zeros(size(signage_gradd_flagg));
%             gradient_flagg_c_2(gradient_flagg_c) = -signage_gradd_flagg(gradient_flagg_c);
%             
%             gradient_xxx_c(flaggg) = gradient_flagg_c_2(:,1);
%             gradient_yyy_c(flaggg) = gradient_flagg_c_2(:,2);
%             gradient_zzz_c(flaggg) = gradient_flagg_c_2(:,3);
%         end
        %%% %}
        
        
        current_x_flaggg_brain = current_x(flaggg_brain) + gradient_xxx_c;
        current_y_flaggg_brain = current_y(flaggg_brain) + gradient_yyy_c;
        current_z_flaggg_brain = current_z(flaggg_brain) + gradient_zzz_c;
        
        
        current_x_flaggg_brain(current_x_flaggg_brain < 0.5) = 0.5;
        current_y_flaggg_brain(current_y_flaggg_brain < 0.5) = 0.5;
        current_z_flaggg_brain(current_z_flaggg_brain < 0.5) = 0.5;
        
        current_x_flaggg_brain(current_x_flaggg_brain >= image_size(1)+0.5) = image_size(1)+0.499;
        current_y_flaggg_brain(current_y_flaggg_brain >= image_size(2)+0.5) = image_size(2)+0.499;
        current_z_flaggg_brain(current_z_flaggg_brain >= image_size(3)+0.5) = image_size(3)+0.499;
        
        %         flaggg_wrong = find(ismember(sub2ind(image_size,round(current_x_flaggg_brain),round(current_y_flaggg_brain),round(current_z_flaggg_brain)),shooting_wrong));
        %         for jj = 1:length(flaggg_wrong)
        %             xyz_w = [current_x_flaggg_brain(flaggg_wrong(jj)),current_y_flaggg_brain(flaggg_wrong(jj)),current_z_flaggg_brain(flaggg_wrong(jj))];
        %             [~,ind_w] = min( sum(((xyz_s - xyz_w).*(xyz_s - xyz_w)),2));
        %
        %             current_x_flaggg_brain(flaggg_wrong(jj)) = xyz_s(ind_w,1);
        %             current_y_flaggg_brain(flaggg_wrong(jj)) = xyz_s(ind_w,2);
        %             current_z_flaggg_brain(flaggg_wrong(jj)) = xyz_s(ind_w,3);
        %         end
        
        current_x(flaggg_brain) = current_x_flaggg_brain;
        current_y(flaggg_brain) = current_y_flaggg_brain;
        current_z(flaggg_brain) = current_z_flaggg_brain;
        
        still_moving_count = nnz(gradient_xxx_c ~= 0 | gradient_yyy_c ~= 0 | gradient_zzz_c ~= 0);
    else
        break;
    end
    waitbar((1-still_moving_count./tot_pix),f,[num2str(still_moving_count), '-pix-left-on-step-', num2str(ii)]);
    
end
close(f)

xxx = round(current_x);
yyy = round(current_y);
zzz = round(current_z);

finn_ind = sub2ind(size(label_in),xxx,yyy,zzz);



% current_dimention = size(image_cortex_minus_one);

% save projection_10u_pad_1.mat current_dimention init_ind indexess