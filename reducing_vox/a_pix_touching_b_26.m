function [idx_out] = a_pix_touching_b_26(temp_data,a,b)

temp_data_t = padarray(temp_data,[1 1 1], 0, 'both');
idx_a = find(ismember(temp_data_t,a));
idx_a_l = false(size(idx_a));

for ii = 1:3
    for jj = 1:3
        for kk =1:3
            if ~(ii==2 & jj == 2 & kk ==2)
                neibors_idx_mod = (sub2ind(size(temp_data_t), ii, jj, kk ) - sub2ind(size(temp_data_t), 2,2,2 ))';
                idx_a_l = idx_a_l | ismember(temp_data_t(idx_a + neibors_idx_mod),b);
                
            end
        end
    end
end

idx_out = idx_a(idx_a_l);
[xxx, yyy, zzz] = ind2sub(size(temp_data_t),idx_out);
idx_out = sub2ind(size(temp_data), xxx-1, yyy-1, zzz-1);
