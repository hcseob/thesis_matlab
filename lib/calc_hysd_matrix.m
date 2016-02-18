function [h, s, d] = calc_hysd_matrix(x, y, N)
x = x(:);
y = y(:);

K = length(x);
X = nan(K, N);
for k = 1:K
    x_shifted = circshift(x, N+1-k);
    X(k, :) = transpose(x_shifted(1:N));
end
h = [ones(K,1), X]\y;
% h0 = h(1);
s = [ones(K,1), X]*h;
h = wrev(h(2:end));
d = y-s;
end