function [final_potential] = solving_laplace_equation(S,RHS,label_in,cnete_pixr)
tic

xxxxxx = gmres(S,RHS,[],1e-8,10); 
toc


for ii = 1:360
tic

xxxxxx = gmres(S,RHS,[],1e-5,10,[],[],xxxxxx); 
toc

end

% save -v7.3 20200909.mat


final_potential = zeros(size(label_in));

potential_from_zero = xxxxxx +2;
final_potential(cnete_pixr) = potential_from_zero;

% volumeViewer(final_potential)

