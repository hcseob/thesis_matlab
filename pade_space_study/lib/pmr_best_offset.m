function [pmr_opt, os_opt] = pmr_best_offset(p)
for offset = 1:50
    p_baud = p(1+offset:50:end);
    pmr(offset) = max(p_baud)/sum(abs(p_baud));
end
[pmr_opt, os_opt] = max(pmr);
end