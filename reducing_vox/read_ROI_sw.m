function [list_of_all_ROI_inside] = read_ROI_sw(NNN,T)





ROI_table.id = table2array(T(:,1));
ROI_table.parent = table2array(T(:,8));

ROI_table.idx = find(ROI_table.id);
[~,ROI_table.p_idx]=ismember(ROI_table.parent,ROI_table.id);
ROI_table.name = table2array(T(:,2));

G = digraph(ROI_table.p_idx(2:end), ROI_table.idx(2:end), 1, ROI_table.name);
%plot(G)


list_of_all_ROI_inside = find(~isinf(distances(G,find(ROI_table.id == NNN))));

%fprintf(['self: ', ROI_table.name{find(ROI_table.id == NNN)}, '\n']);

%for ii = 1:length(list_of_all_ROI_inside)
%    fprintf(['ROI inside: ', ROI_table.name{list_of_all_ROI_inside(ii)}, '\n']);
%end

list_of_all_ROI_inside = ROI_table.id(list_of_all_ROI_inside);