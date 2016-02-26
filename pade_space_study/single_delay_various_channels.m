function single_delay_various_channels
run('~/thesis/matlab/thesis.m');
load('../../data/channels/channels.mat');

pmr_ibm_bl = pmr_best_offset(p_norm.ibm);
[amp_ibm, pmr_ibm, c_ibm, delays] = delay_sweep(p_norm.ibm, p_norm.t);

pmr_nel0_bl = pmr_best_offset(p_norm.nel0);
[amp_nel0, pmr_nel0, c_nel0, delays] = delay_sweep(p_norm.nel0, p_norm.t);

pmr_nel1_bl = pmr_best_offset(p_norm.nel1);
[amp_nel1, pmr_nel1, c_nel1, delays] = delay_sweep(p_norm.nel1, p_norm.t);

pmr_nel2_bl = pmr_best_offset(p_norm.nel2);
[amp_nel2, pmr_nel2, c_nel2, delays] = delay_sweep(p_norm.nel2, p_norm.t);

pmr_nel3_bl = pmr_best_offset(p_norm.nel3);
[amp_nel3, pmr_nel3, c_nel3, delays] = delay_sweep(p_norm.nel3, p_norm.t);

figure;
subplot(211);
semilogx(delays/1e-12, pmr_ibm/pmr_ibm_bl, '-k', 'linewidth', 2); hold all;
% semilogx(delays/1e-12, pmr_nel0/pmr_nel0_bl); hold all;
% semilogx(delays/1e-12, pmr_nel1/pmr_nel1_bl); hold all;
semilogx(delays/1e-12, pmr_nel2/pmr_nel2_bl, '--', 'color', stanford_red, 'linewidth', 2); hold all;
semilogx(delays/1e-12, pmr_nel3/pmr_nel3_bl, 'o-', 'color', new_blue, 'linewidth', 2); hold all;
xlabel('x1', 'fontsize', 14); 
ylabel('y1', 'fontsize', 14); 
set(gca, 'fontsize', 12);

subplot(212);
semilogx(delays/1e-12, amp_ibm, '-k', 'linewidth', 2); hold all;
% semilogx(delays/1e-12, amp_nel0); hold all;
% semilogx(delays/1e-12, amp_nel1); hold all;
semilogx(delays/1e-12, amp_nel2, '--', 'color', stanford_red, 'linewidth', 2); hold all;
semilogx(delays/1e-12, amp_nel3, 'o-', 'color', new_blue, 'linewidth', 2); hold all;
xlabel('x2', 'fontsize', 14); 
ylabel('y2', 'fontsize', 14); 
set(gca, 'fontsize', 12);

print('-depsc', './figures/one_tap_3_channels');

end

function [amp, pmr, c, delays] = delay_sweep(pulse, t)
num_taps = 2; 
bits = 5;
delays = logspace(0, 2, 40)*1e-12;
for k = 1:length(delays)
    delay = delays(k); 
    delay_cell = bessel_sys(1, delay);
    for j = 1:num_taps
        ps(:, j) = lsim((delay_cell)^(j-1), pulse, t);
    end
    c = brute_force_pmr_opt(ps, bits, 0.1);
    amp(k) = max(ps*c);
    pmr(k) = pmr_best_offset(ps*c);
end

end