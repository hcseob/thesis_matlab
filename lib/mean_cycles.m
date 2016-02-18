function [vout_mean, vout, Nsym] = mean_cycles(vin)
Nsym = find_Nsym(vin);
L = 254*Nsym;
K = floor(length(vin)/L);
vout = zeros(L, K);
for k = 1:K
    vout(:, k) = vin((k-1)*L+1:k*L);
end
vout_mean = mean(vout, 2);
end