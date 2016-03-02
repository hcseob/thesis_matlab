clear all; close all;
load('BW_sweep.mat');

delay = 25e-12;
pulse = p_norm.nel2;
t = p_norm.t;
figure; hold all;
for k = 1:4:20
    BW = BWs(k);
    coeffs = c5(:, k);
    [pout, ps] = ffe_pade1(pulse, t, delay, BW, coeffs);
    [mv, mi] = max(pout);
    pout_norm = circshift(pout, length(pout)/2-mi)/mv;
    plot(t-750e-12, pout_norm); hold all; 
end
xlim([-400e-12, 400e-12]);