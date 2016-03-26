function amplitude_sweep
run('~/thesis/matlab/thesis.m');
load('../../data/channels/channels.mat');

pmr_bl = pmr_best_offset(p_norm.nel2);

run_sweeps = false;
if run_sweeps
    N = 20;
    amps = zeros(N, 5);
    pmrs = zeros(N, 5);
%     [amps(:, 2), pmrs(:, 2), c2, amp_lim] = delay_sweep(p_norm.nel2, p_norm.t, 2, N);
    [amps(:, 3), pmrs(:, 3), c3, amp_lim] = delay_sweep(p_norm.nel2, p_norm.t, 3, N);
    [amps(:, 4), pmrs(:, 4), c4, amp_lim] = delay_sweep(p_norm.nel2, p_norm.t, 4, N, [c3; zeros(1, N)]);
    [amps(:, 5), pmrs(:, 5), c5, amp_lim] = delay_sweep(p_norm.nel2, p_norm.t, 5, N, [c4; zeros(1, N)]);
    save('amplitude_sweep.mat');
else
    load('amplitude_sweep.mat');
end

figure;
plot(amp_lim, pmrs(:, 3)/pmr_bl, '-k', 'linewidth', 3); hold all;
plot(amp_lim, pmrs(:, 4)/pmr_bl, '--', 'color', stanford_red, 'linewidth', 3); hold all;
plot(amp_lim, pmrs(:, 5)/pmr_bl, ':', 'color', new_blue, 'linewidth', 3); hold all;
xlabel('Main Cursor Scale Factor', 'fontsize', 18); 
ylabel('PMR', 'fontsize', 18); 
ylim([1, 4])
set(gca, 'fontsize', 18);
save_fig('./figures/amplitude_sweep.eps');

plot_amps = true;
if plot_amps
    figure;
    plot(amp_lim, amps(:, 3), '-k', 'linewidth', 3); hold all;
    plot(amp_lim, amps(:, 4), '--', 'color', stanford_red, 'linewidth', 3); hold all;
    plot(amp_lim, amps(:, 5), ':', 'color', new_blue, 'linewidth', 3); hold all;
    plot(amp_lim, amp_lim, '--k', 'linewidth', 2);
    xlabel('Attenuation Lower Bound', 'fontsize', 18); 
    ylabel('Attenuation', 'fontsize', 18); 
    ylim([0, 1])
    set(gca, 'fontsize', 18);
end

end

function [amp, pmr, c, amp_lims] = delay_sweep(pulse, t, num_taps, N, c_inits)
if nargin < 5; c_inits = zeros(num_taps, N); end;
delay_cell = pade_sys(1, 25e-12);
bits = 4;
amp_lims = linspace(0.1, 1, N);
for k = 1:length(amp_lims)
    disp(k);
    amp_lim = amp_lims(k);
    for j = 1:num_taps
        ps(:, j) = lsim((delay_cell)^(j-1), pulse, t);
    end
%     c(:, k) = brute_force_pmr_opt(ps, bits, amp_lim);
    c(:, k) = optim_pmr_opt(ps, amp_lim, c_inits(:, k));
    amp(k) = max(ps*c(:, k));
    pmr(k) = pmr_best_offset(ps*c(:, k));
end

end