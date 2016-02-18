function [c, s, d] = calc_csd(x, y)
yi = y-mean(y);
xi = x-mean(x);
c = mean(yi.*xi)/mean(xi.^2);
s = c*xi;
d = yi-s;
end
