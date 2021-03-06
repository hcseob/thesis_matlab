function bit_res_sweep
run('~/thesis/matlab/thesis.m'); addpath('./lib');
load('../../data/channels/channels.mat');

pmr_bl = pmr_best_offset(p_norm.nel2);

run_sweeps = false;
if run_sweeps
    N = 5;
    amps = zeros(N, 5);
    pmrs = zeros(N, 5);
    [amps(:, 2), pmrs(:, 2), c2, bitss] = delay_sweep(p_norm.nel2, p_norm.t, 2, N);
    [amps(:, 3), pmrs(:, 3), c3, bitss] = delay_sweep(p_norm.nel2, p_norm.t, 3, N);
    [amps(:, 4), pmrs(:, 4), c4, bitss] = delay_sweep(p_norm.nel2, p_norm.t, 4, N);
    [amps(:, 5), pmrs(:, 5), c5, bitss] = delay_sweep(p_norm.nel2, p_norm.t, 5, N);
    save('bit_res_sweep.mat');
else
    load('bit_res_sweep.mat');
end

figure;
plot(bitss, pmrs(:, 3)/pmr_bl, '-ok', 'linewidth', 3, 'markerfacecolor', 'k', 'markersize', 8); hold all;
plot(bitss, pmrs(:, 4)/pmr_bl, '--o', 'color', stanford_red, 'linewidth', 3, 'markerfacecolor', stanford_red, 'markersize', 8); hold all;
plot(bitss, pmrs(:, 5)/pmr_bl, ':o', 'color', new_blue, 'linewidth', 3, 'markerfacecolor', new_blue, 'markersize', 8); hold all;
xlabel('Coefficient Bit Resolution', 'fontsize', 18); 
ylabel('DR Improvement', 'fontsize', 18); 
ylim([1, 4])
set(gca, 'xtick', 1:5);
set(gca, 'fontsize', 18);
legend('n = 3', 'n = 4', 'n = 5', 'location', 'northwest');
save_fig('./figures/bit_res_sweep.eps');

plot_amps = true;
if plot_amps
    figure;
    plot(bitss, amps(:, 3), '-k', 'linewidth', 2); hold all;
    plot(bitss, amps(:, 4), '--', 'color', stanford_red, 'linewidth', 2); hold all;
    plot(bitss, amps(:, 5), ':', 'color', new_blue, 'linewidth', 2); hold all;
    xlabel('Coefficient Bit Resolution', 'fontsize', 18); 
    ylabel('Attenuation', 'fontsize', 18); 
    ylim([0, 1]);
    set(gca, 'fontsize', 18);
end

end

function [amp, pmr, c, bitss] = delay_sweep(pulse, t, num_taps, N)
delay_cell = pade_sys(1, 25e-12);
bitss = 1:N;
for k = 1:length(bitss)
    disp(k);
    bits = bitss(k);
    for j = 1:num_taps
        ps(:, j) = lsim((delay_cell)^(j-1), pulse, t);
    end
    c(:, k) = brute_force_pmr_opt(ps, bits, 0.5);
%     disp(c);
    amp(k) = max(ps*c(:, k));
    pmr(k) = pmr_best_offset(ps*c(:, k));
end

end