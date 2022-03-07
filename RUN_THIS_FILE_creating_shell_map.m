clear
close all

nii_in = 'temp12.nii' ;
label_in = niftiread(nii_in);

% the nii setting is as followed:
% image_brain = (label_in == 1);
% image_brain_shell_in = (label_in == 3);
% image_brain_shell_out = (label_in == 2);
% image_boundary_condition = (label_in == 4);


[S,RHS,cnete_pixr] = creating_laplace_equation_set(label_in);
save([num2str(now),'.mat'],'-v7.3') 


[final_potential] = solving_laplace_equation(S,RHS,label_in,cnete_pixr);
save([num2str(now),'.mat'],'-v7.3') 

% volumeViewer( final_potential)

[gradient] = making_p_gradient(final_potential, label_in);
save([num2str(now),'.mat'],'-v7.3') 

% volumeViewer( gradient(:,:,:,1))
% volumeViewer( gradient(:,:,:,2))
% volumeViewer( gradient(:,:,:,3))

[init_ind, finn_ind] = making_projection_shell(gradient, label_in);
save([num2str(now),'.mat'],'-v7.3') 