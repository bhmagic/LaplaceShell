function [idx_out] = a_pix_touching_b(temp_data,a,b)

temp_data_t = padarray(temp_data,[1 1 1], 0, 'both');

xyz = [];
for ii = 1:3
    for jj = 1:3
        for kk =1:3
            if ~(ii==2 & jj == 2 & kk ==2)
                xyz = [xyz; ii,jj,kk];
            end
        end
    end
end

neibors_idx_mod = (sub2ind(size(temp_data_t), xyz(:,1), xyz(:,2), xyz(:,3) ) - sub2ind(size(temp_data_t), 2,2,2 ))';

idx_a = find(temp_data_t == a);

idx_a_p = idx_a.*ones(size(neibors_idx_mod));

idx_a_p = idx_a_p + neibors_idx_mod;

idx_a_p = temp_data_t(idx_a_p) == b;

idx_a_p = max(idx_a_p,[],2);

idx_out = idx_a(idx_a_p);