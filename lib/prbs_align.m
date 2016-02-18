function y2_aligned = prbs_align(y1, y2)

for k = 1:length(y2)
    y2_current = circshift(y2, k);
    corr_sv(k) = corr(y1, y2_current);
end

[~, k_opt] = max(abs(corr_sv));
y2_aligned = circshift(y2, k_opt);
if corr_sv(k_opt) < 0
    y2_aligned = -y2_aligned;
end