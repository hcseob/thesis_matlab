function alpha_ratio_sweep
run('~/thesis/matlab/thesis.m');
load('../../data/channels/channels.mat');

pmr_bl = pmr_best_offset(p_norm.nel2);
run_sweeps = true;
if run_sweeps
    N = 10;
    alphas = linspace(0, 1, N);
    amps = zeros(N, 5);
    pmrs = zeros(N, 5);
    [amp_neq5, pmr_neq5, c2] = delay_sweep(p_norm.nel2, p_norm.t, 3, 3, alphas);
    [amp_neq4, pmr_neq4, c2] = delay_sweep(p_norm.nel2, p_norm.t, 4, 3, alphas);
    [amp_neq3, pmr_neq3, c2] = delay_sweep(p_norm.nel2, p_norm.t, 5, 3, alphas);
    [amp_eq5, pmr_eq5, c2] = delay_sweep(p_norm.nel2, p_norm.t, 3, 3, alphas, true);
    [amp_eq4, pmr_eq4, c2] = delay_sweep(p_norm.nel2, p_norm.t, 4, 3, alphas, true);
    [amp_eq3, pmr_eq3, c2] = delay_sweep(p_norm.nel2, p_norm.t, 5, 3, alphas, true);
    save('alpha_ratio_sweep.mat');
else
    load('alpha_ratio_sweep.mat');
end

figure;
plot(alphas, pmr_neq3/pmr_bl, '-k', 'linewidth', 2); hold all;
plot(alphas, pmr_neq4/pmr_bl, '--', 'color', stanford_red, 'linewidth', 2); hold all;
plot(alphas, pmr_neq5/pmr_bl, ':', 'color', new_blue, 'linewidth', 2); hold all;
xlabel('Pole and Zero Ratio', 'fontsize', 18); 
ylabel('DR Improvement', 'fontsize', 18); 
ylim([1, 4]);
legend('n=3', 'n=4', 'n=5', 'location', 'northwest');
set(gca, 'fontsize', 18);
save_fig('./figures/alpha_ratio_sweep.eps');

figure;
plot(alphas, pmr_eq3/pmr_bl, '-k', 'linewidth', 2); hold all;
plot(alphas, pmr_eq4/pmr_bl, '--', 'color', stanford_red, 'linewidth', 2); hold all;
plot(alphas, pmr_eq5/pmr_bl, ':', 'color', new_blue, 'linewidth', 2); hold all;
xlabel('Pole and Zero Ratio', 'fontsize', 18); 
ylabel('DR Improvement', 'fontsize', 18); 
ylim([1, 4]);
legend('n=3', 'n=4', 'n=5', 'location', 'northwest');
set(gca, 'fontsize', 18);
save_fig('./figures/alpha_ratio_sweep_constant_tau.eps');

plot_amps = false;
if plot_amps
    figure;
    plot(alphas, amp_neq3, '-k', 'linewidth', 2); hold all;
    plot(alphas, amp_neq4, '--', 'color', stanford_red, 'linewidth', 2); hold all;
    plot(alphas, amp_neq5, '-.', 'color', new_blue, 'linewidth', 2); hold all;
    xlabel('Pole/Zero Ratio', 'fontsize', 18); 
    ylabel('Attenuation', 'fontsize', 18); 
    ylim([0, 3])
    set(gca, 'fontsize', 18);
end

end

function [amp, pmr, c] = delay_sweep(pulse, t, num_taps, bits, alphas, constant_tau)
if nargin < 6; constant_tau = false; end
for k = 1:length(alphas)
    disp(k);
    a = alphas(k);
    if constant_tau
        delay_cell = pade_sys(1, 25e-12, a);
    else
        delay_cell = pade_sys(1, 2/(1+a)*25e-12, a);
    end
    for j = 1:num_taps
        ps(:, j) = lsim((delay_cell)^(j-1), pulse, t);
    end
    c(:, k) = brute_force_pmr_opt(ps, bits, 0.5);
%     c(:, k) = optim_pmr_opt(ps, 0.5);
    
    amp(k) = max(ps*c(:, k));
    pmr(k) = pmr_best_offset(ps*c(:, k));
end

end