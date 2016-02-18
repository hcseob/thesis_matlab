function [y_actual, y_lms, d, h_hat] = lms_norm(x, y, h_hat, numLoops, mu)
if size(x,1) > size(x,2) % if column vector
    x = transpose(x); % make row vector
end
N = length(h_hat);
for j = 1:length(x) - N
    xn = x(j+N:-1:j+1);
    yn = y(j+N);
    y_hat = xn * h_hat';
    e = yn - y_hat;
    h_hat = mu*e*xn/(xn*xn')+h_hat;
end
y_lms = convData(x, h_hat);
y_lms = y_lms(N:end);
y_actual = y(N:end)';
d = y_actual - y_lms;
if numLoops ~= 1
    h_hat(1)
    [~, ~, ~, h_hat] = lms_norm(x, y, h_hat, numLoops-1, mu);
end