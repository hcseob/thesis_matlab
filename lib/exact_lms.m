function [y_actual, y_approx, d, h] = exact_lms(x, y, N)
K = length(x)-N+1;
X = nan(K, N);
for k = 1:K
    X(k, :) = x(k:k+N-1)';
end
h = X\y(N:1:end);
h = wrev(h);
y_approx = convData(x, h);
y_actual = y(N:end);
y_approx = y_approx(N:end);
d = y_actual-y_approx;
end