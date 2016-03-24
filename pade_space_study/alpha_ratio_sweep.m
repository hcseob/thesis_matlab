function alpha_ratio_sweep
run('~/thesis/matlab/thesis.m');
load('../../data/channels/channels.mat');

pmr_bl = pmr_best_offset(p_norm.nel2);
run_sweeps = false;
if run_sweeps
    num_taps = 5;
    N = 10;
    alphas = logspace(-1, 1, N);
    amps = zeros(N, 5);
    pmrs = zeros(N, 5);
    [amps(:, 2), pmrs(:, 2), c2] = delay_sweep(p_norm.nel2, p_norm.t, num_taps, 2, alphas);
    [amps(:, 3), pmrs(:, 3), c3] = delay_sweep(p_norm.nel2, p_norm.t, num_taps, 3, alphas);
    [amps(:, 4), pmrs(:, 4), c4] = delay_sweep(p_norm.nel2, p_norm.t, num_taps, 4, alphas);
    [amps(:, 5), pmrs(:, 5), c5] = delay_sweep(p_norm.nel2, p_norm.t, num_taps, 5, alphas);
    save('alpha_ratio_sweep.mat');
else
    load('alpha_ratio_sweep.mat');
end

figure;
subplot(211);
semilogx(alphas, pmrs(:, 5)/pmr_bl, '-k', 'linewidth', 2); hold all;
% semilogx(alphas, pmrs(:, 4)/pmr_bl, '--', 'color', stanford_red, 'linewidth', 2); hold all;
% semilogx(alphas, pmrs(:, 3)/pmr_bl, '-.', 'color', new_blue, 'linewidth', 2); hold all;
xlabel('Pole/Zero Ratio', 'fontsize', 18); 
ylabel('DR Improvement', 'fontsize', 18); 
ylim([1, 5]);
% legend('bits=3', 'bits=4', 'bits=5');
set(gca, 'fontsize', 18);

subplot(212);
semilogx(alphas, amps(:, 5), '-k', 'linewidth', 2); hold all;
% semilogx(alphas, amps(:, 4), '--', 'color', stanford_red, 'linewidth', 2); hold all;
% semilogx(alphas, amps(:, 5), '-.', 'color', new_blue, 'linewidth', 2); hold all;
xlabel('Pole/Zero Ratio', 'fontsize', 18); 
ylabel('Attenuation', 'fontsize', 18); 
ylim([0, 3])
set(gca, 'fontsize', 18);

print('-depsc', './figures/alpha_ratio_sweep');

end

function [amp, pmr, c] = delay_sweep(pulse, t, num_taps, bits, alphas)
for k = 1:length(alphas)
    disp(k);
    delay_cell = pade_sys(1, 25e-12, alphas(k));
    for j = 1:num_taps
        ps(:, j) = lsim((delay_cell)^(j-1), pulse, t);
    end
    c(:, k) = brute_force_pmr_opt(ps, bits, 0.2);
    amp(k) = max(ps*c(:, k));
    pmr(k) = pmr_best_offset(ps*c(:, k));
end

end