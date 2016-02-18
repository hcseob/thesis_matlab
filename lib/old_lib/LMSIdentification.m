function h_hat = LMSIdentification(x, y, h_hat_init, mu, delay, numLoops)
if size(x,1) > size(x,2) % if column vector
    x = transpose(x); % make row vector
end
N = length(h_hat_init);
h_hat = h_hat_init;
for j = 1:length(x) - N - abs(delay)
    xn = x(j + N - 1:-1:j);
    yn = y(j+N-delay);
    y_hat = xn * h_hat';
    e = yn - y_hat;
    h_hat = e * mu * xn + h_hat;
end

if numLoops ~= 1
    h_hat = LMSIdentification(x, y, h_hat, mu, delay, numLoops-1);
end