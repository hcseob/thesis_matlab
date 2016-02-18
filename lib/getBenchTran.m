function [y t ys] = getBenchTran(COEFF,TIME,coeffind,baudind,varargin)
periods = [1000e-12,200e-12,100e-12,50e-12,75e-12,62.5e-12];
Ns = round(periods(baudind)/12.5e-12);
if baudind > 4
    baudind = baudind - 4;
end
x = squeeze(COEFF(coeffind,baudind,:));
told = squeeze(TIME(coeffind,baudind,:));

Lprbs = 254 * Ns;
M = length(x);
y = zeros(Lprbs,1);
K = floor(M/Lprbs);
ys = nan(Lprbs,K);
for k = 1:K
    ys(:,k) = x(1+(k-1)*Lprbs:k*Lprbs);
    y = y + ys(:,k);
end
y = y/K;
if ~isempty(varargin)
    tnew = varargin{1};
    t = tnew((tnew > told(1)) & (tnew < told(Lprbs)));
    y = interp1(told(1:Lprbs),y,t);
    ysold = ys;
    ys = nan(length(t),K);
    for k = 1:K
        ys(:,k) = interp1(told(1:Lprbs),ysold(:,k),t);
    end
else
    t = told(1:Lprbs);
end