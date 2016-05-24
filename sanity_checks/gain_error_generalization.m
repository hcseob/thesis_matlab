clear all; close all;

varf = @(x) var(x)*(length(x)-1)/length(x);
dist = @(x, n) varf(x.^n) - mean(x.^(n+1))^2/mean(x.^2);
alpha = @(x, n) mean(x.^(n+1))/mean(x.^2);

N = 100;

xs = cos(2*pi*(0:N-1)'/N)*sqrt(2);
as = mean(xs.^4)/mean(xs.^2);
d3s = varf(xs.^3) - as^2*mean(xs.^2);

xg = randn(N, 1);
ag = mean(xg.^4)/mean(xg.^2);
d3g = varf(xg.^3) - ag^2*mean(xg.^2);


x1 = ones(N, 1);
x1(1:2:end) = -1;

x2 = -ones(N, 1)/sqrt(N-1);
x2(1) = sqrt(N-1);

disp([dist(xs, 3), dist(xg, 3), dist(x1, 3), dist(x2, 3)]);


%%
figure; hold all;
plot(xs);
plot(xg);
plot(x1);
plot(x2);