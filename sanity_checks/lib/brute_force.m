function [c_opt] = brute_force(ps, N, threshold)
if nargin < 3; threshold = 0; end;

num_taps = size(ps, 2);
c_init = ones(num_taps-1, 1)*(-N);
p2 = ps(:, 2);
P = ps(:, [1, 3:num_taps]);

pmr_opt = inf;
c = nan;
while ~isequal(c, c_init)
    if isnan(c); c = c_init; end;
    po = P*c/N + p2;
    if max(po) >= threshold
        pmr = sum(abs(po))/max(po);
        if pmr < pmr_opt
            pmr_opt = pmr;
            c_opt = [c(1)/N; 1; c(2:end)/N];
        end
    end
    c = get_next_c(N, c);
end
end

function next_c = get_next_c(N, c)
next_c = c;
for k = 1:length(c)
    if c(k) == N
        next_c(k) = -N;
    else
        next_c(k) = c(k) + 1;
        break;
    end
end
end