function delay_time_sweep_2_taps
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
save('delay_time_sweep_2_taps.mat');

figure;
plot(delays/1e-12, pmr_ibm/pmr_ibm_bl, '-k', 'linewidth', 3); hold all;
% plot(delays/1e-12, pmr_nel0/pmr_nel0_bl); hold all;
% plot(delays/1e-12, pmr_nel1/pmr_nel1_bl); hold all;
plot(delays/1e-12, pmr_nel2/pmr_nel2_bl, '--', 'color', stanford_red, 'linewidth', 3); hold all;
plot(delays/1e-12, pmr_nel3/pmr_nel3_bl, ':', 'color', new_blue, 'linewidth', 3); hold all;
xlabel('Delay Time (ps)', 'fontsize', 18); 
ylabel('DR Improvement', 'fontsize', 18); 
ylim([1, 4]);
set(gca, 'fontsize', 18);
legend('1m FR4 [ibm]', '1m FR4 [nel]', '1m Meg [nel]');
save_fig('./figures/delay_time_sweep_2_taps.eps');

plot_amps = true;
if plot_amps
    figure;
    semilogx(delays/1e-12, amp_ibm, '-k', 'linewidth', 2); hold all;
    % semilogx(delays/1e-12, amp_nel0); hold all;
    % semilogx(delays/1e-12, amp_nel1); hold all;
    semilogx(delays/1e-12, amp_nel2, '--', 'color', stanford_red, 'linewidth', 2); hold all;
    semilogx(delays/1e-12, amp_nel3, ':', 'color', new_blue, 'linewidth', 2); hold all;
    xlabel('Delay Time (ps)', 'fontsize', 18); 
    ylabel('Attenuation', 'fontsize', 18); 
    set(gca, 'fontsize', 18);
    ylim([0, 1]);
end
end

function [amp, pmr, c, delays] = delay_sweep(pulse, t)
num_taps = 2; 
bits = 5;
delays = logspace(0, 2, 20)*1e-12;
for k = 1:length(delays)
    delay = delays(k); 
    delay_cell = bessel_sys(1, delay);
    for j = 1:num_taps
        ps(:, j) = lsim((delay_cell)^(j-1), pulse, t);
    end
    c(:, k) = brute_force_pmr_opt(ps, bits, 0.5);
    amp(k) = max(ps*c(:, k));
    pmr(k) = pmr_best_offset(ps*c(:, k));
end

end