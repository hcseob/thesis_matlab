function [pmr_opt, os_opt] = pmr_best_offset(ps, coeffs)
for offset = 1:50
    ps_baud = ps(1+offset:50:end, :);
    p_baud = ps_baud*coeffs;
    pmr(offset) = max(p_baud)/sum(abs(p_baud));
end
[pmr_opt, os_opt] = max(pmr);
end