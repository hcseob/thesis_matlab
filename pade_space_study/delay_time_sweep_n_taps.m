function delay_time_sweep_n_taps
run('~/thesis/matlab/thesis.m');
load('../../data/channels/channels.mat');

pmr_bl = pmr_best_offset(p_norm.nel2);

run_sweeps = false;
if run_sweeps
    N = 20;
    amps = zeros(N, 5);
    pmrs = zeros(N, 5);
%     [amps(:, 2), pmrs(:, 2), c2, delays] = delay_sweep(p_norm.nel2, p_norm.t, 2, N);
    [amps(:, 3), pmrs(:, 3), c3, delays] = delay_sweep(p_norm.nel2, p_norm.t, 3, N);
    [amps(:, 4), pmrs(:, 4), c4, delays] = delay_sweep(p_norm.nel2, p_norm.t, 4, N, [c3; zeros(1, N)]);
    [amps(:, 5), pmrs(:, 5), c5, delays] = delay_sweep(p_norm.nel2, p_norm.t, 5, N, [c4; zeros(1, N)]);
    disp(size(c5));
    save('delay_time_sweep_n_taps.mat');
else
    load('delay_time_sweep_n_taps.mat');
end

figure;
plot(delays/1e-12, pmrs(:, 3)/pmr_bl, '-k', 'linewidth', 3); hold all;
plot(delays/1e-12, pmrs(:, 4)/pmr_bl, '--', 'color', stanford_red, 'linewidth', 3); hold all;
plot(delays/1e-12, pmrs(:, 5)/pmr_bl, ':', 'color', new_blue, 'linewidth', 3); hold all;
plot([1, 1]*30, [1, 4], ':', 'color', 'k', 'linewidth', 1); hold all;
xlabel('Delay Time (ps)', 'fontsize', 18); 
ylabel('DR Improvement', 'fontsize', 18); 
set(gca, 'fontsize', 18);
ylim([1, 4]);
legend('n = 3', 'n = 4', 'n = 5');
save_fig('./figures/delay_time_sweep_n_taps.eps');

plot_amps = false;
if plot_amps
    figure;
    plot(delays/1e-12, amps(:, 3), '-k', 'linewidth', 2); hold all;
    plot(delays/1e-12, amps(:, 4), '--', 'color', stanford_red, 'linewidth', 2); hold all;
    plot(delays/1e-12, amps(:, 5), ':', 'color', new_blue, 'linewidth', 2); hold all;
    xlabel('Delay Time (ps)', 'fontsize', 18); 
    ylabel('Attenuation', 'fontsize', 18); 
    set(gca, 'fontsize', 18);
    ylim([0, 1]);
end
end

function [amp, pmr, c, delays] = delay_sweep(pulse, t, num_taps, N, c_inits)
if nargin < 5; c_inits = zeros(num_taps, N); end;
bits = 4;
delays = logspace(1, 2, N)*1e-12;
for k = 1:length(delays)
    disp(k);
    delay = delays(k);
    delay_cell = pade_sys(1, delay);
    for j = 1:num_taps
        ps(:, j) = lsim((delay_cell)^(j-1), pulse, t);
    end
%     c(:, k) = brute_force_pmr_opt(ps, bits, 0.1);
    c(:, k) = optim_pmr_opt(ps, 0.5, c_inits(:, k));
    amp(k) = max(ps*c(:, k));
    pmr(k) = pmr_best_offset(ps*c(:, k));
end

end