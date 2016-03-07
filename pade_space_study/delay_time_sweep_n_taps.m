function delay_time_sweep_n_taps
run('~/thesis/matlab/thesis.m');
load('../../data/channels/channels.mat');

pmr_bl = pmr_best_offset(p_norm.nel2);

run_sweeps = false;
if run_sweeps
    N = 20;
    amps = zeros(N, 5);
    pmrs = zeros(N, 5);
    [amps(:, 2), pmrs(:, 2), c2, delays] = delay_sweep(p_norm.nel2, p_norm.t, 2, N);
    [amps(:, 3), pmrs(:, 3), c3, delays] = delay_sweep(p_norm.nel2, p_norm.t, 3, N);
    [amps(:, 4), pmrs(:, 4), c4, delays] = delay_sweep(p_norm.nel2, p_norm.t, 4, N);
    [amps(:, 5), pmrs(:, 5), c5, delays] = delay_sweep(p_norm.nel2, p_norm.t, 5, N);
    save('delay_time_sweep_n_taps.mat');
else
    load('delay_time_sweep_n_taps.mat');
end

figure;
subplot(211);
semilogx(delays/1e-12, pmrs(:, 3)/pmr_bl, '-k', 'linewidth', 2); hold all;
semilogx(delays/1e-12, pmrs(:, 4)/pmr_bl, '--', 'color', stanford_red, 'linewidth', 2); hold all;
semilogx(delays/1e-12, pmrs(:, 5)/pmr_bl, ':', 'color', new_blue, 'linewidth', 2); hold all;
xlabel('Delay Time [ps]', 'fontsize', 14); 
ylabel('DR Improvement', 'fontsize', 14); 
set(gca, 'fontsize', 14);
ylim([1, 4]);
subplot(212);
semilogx(delays/1e-12, amps(:, 3), '-k', 'linewidth', 2); hold all;
semilogx(delays/1e-12, amps(:, 4), '--', 'color', stanford_red, 'linewidth', 2); hold all;
semilogx(delays/1e-12, amps(:, 5), ':', 'color', new_blue, 'linewidth', 2); hold all;
xlabel('Delay Time [ps]', 'fontsize', 14); 
ylabel('Attenuation', 'fontsize', 14); 
set(gca, 'fontsize', 14);
ylim([0, 1]);
save_fig('./figures/delay_time_sweep_n_taps.eps');

end

function [amp, pmr, c, delays] = delay_sweep(pulse, t, num_taps, N)
bits = 4;
delays = logspace(0, 2, N)*1e-12;
for k = 1:length(delays)
    disp(k);
    delay = delays(k);
    delay_cell = pade_sys(1, delay);
    for j = 1:num_taps
        ps(:, j) = lsim((delay_cell)^(j-1), pulse, t);
    end
    c(:, k) = brute_force_pmr_opt(ps, bits, 0.1);
    amp(k) = max(ps*c(:, k));
    pmr(k) = pmr_best_offset(ps*c(:, k));
end

end