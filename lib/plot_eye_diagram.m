function [vout] =  plot_eye_diagram(vin, Nsym)
vin = vin - mean(vin);
K = floor(length(vin)/Nsym)-2;
vout = nan(K, 2*Nsym+1);
for k = 1:K
    vout(k, :) = vin((k-1)*Nsym+1:(k+1)*Nsym+1);
end
[~, ind] = max(min(abs(vout)));
shift = Nsym + 1 - ind;

vout = nan(K-1, 2*Nsym+1);
for k = 1:K-1
    vout(k, :) = vin(k*Nsym+1-shift:(k+2)*Nsym+1-shift);
end

plot([-Nsym:Nsym], vout, '-k'); hold all;
