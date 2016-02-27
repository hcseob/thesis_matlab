function bandwidth_sweep
run('~/thesis/matlab/thesis.m');
load('../../data/channels/channels.mat');

pmr_bl = pmr_best_offset(p_norm.nel2);

run_sweeps = false;
if run_sweeps
    N = 20;
    amps = zeros(N, 5);
    pmrs = zeros(N, 5);
    [amps(:, 2), pmrs(:, 2), ~, BWs] = delay_sweep(p_norm.nel2, p_norm.t, 2, N);
    [amps(:, 3), pmrs(:, 3), ~, BWs] = delay_sweep(p_norm.nel2, p_norm.t, 3, N);
    [amps(:, 4), pmrs(:, 4), ~, BWs] = delay_sweep(p_norm.nel2, p_norm.t, 4, N);
    [amps(:, 5), pmrs(:, 5), ~, BWs] = delay_sweep(p_norm.nel2, p_norm.t, 5, N);
    save('BW_sweep.mat');
else
    load('BW_sweep.mat');
end

figure;
subplot(211);
semilogx(BWs/1e9, pmrs(:, 3)/pmr_bl, '-k', 'linewidth', 2); hold all;
semilogx(BWs/1e9, pmrs(:, 4)/pmr_bl, '--', 'color', stanford_red, 'linewidth', 2); hold all;
semilogx(BWs/1e9, pmrs(:, 5)/pmr_bl, 'o-', 'color', new_blue, 'linewidth', 2); hold all;
xlabel('x1', 'fontsize', 14); 
ylabel('y1', 'fontsize', 14); 
ylim([1, 4])
set(gca, 'fontsize', 12);

subplot(212);
semilogx(BWs/1e9, amps(:, 3), '-k', 'linewidth', 2); hold all;
semilogx(BWs/1e9, amps(:, 4), '--', 'color', stanford_red, 'linewidth', 2); hold all;
semilogx(BWs/1e9, amps(:, 5), 'o-', 'color', new_blue, 'linewidth', 2); hold all;
xlabel('x2', 'fontsize', 14); 
ylabel('y2', 'fontsize', 14); 
ylim([0, 1])
set(gca, 'fontsize', 12);

print('-depsc', './figures/bandwidth_sweep');

end

function [amp, pmr, c, BWs] = delay_sweep(pulse, t, num_taps, N)
bits = 4;
delay_cell = pade_sys(1, 25e-12);
BWs = logspace(9, 11, N);
for k = 1:length(BWs)
    disp(k);
    BW = BWs(k);
    rc = tf([1], [1/2/pi/BW, 1]);
    for j = 1:num_taps
        ps(:, j) = lsim((delay_cell*rc)^(j-1)*rc^2, pulse, t);
    end
    c = brute_force_pmr_opt(ps, bits, 0.2);
%     disp(c);
    amp(k) = max(ps*c);
    pmr(k) = pmr_best_offset(ps*c);
end

end