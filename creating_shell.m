function [label_in] = creating_shell(label_in)


image_empty  = (label_in == 0);
image_brain  = (label_in == 1);
image_ventrical  = (label_in == 2);


nhood = cat(3, [0 0 0; 0 1 0; 0 0 0], [0 1 0; 1 1 1; 0 1 0], [0 0 0; 0 1 0; 0 0 0]);

image_empty_plus_one = imdilate(image_empty, nhood);
image_outside_shell = image_empty_plus_one & image_brain;

image_brain_plus_one = imdilate(image_brain, nhood);
image_inside_shell = image_brain_plus_one & image_ventrical;

label_in(image_inside_shell) = -2;
label_in(image_outside_shell) = -3;



