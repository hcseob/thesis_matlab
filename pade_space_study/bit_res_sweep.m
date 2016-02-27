function bit_res_sweep
run('~/thesis/matlab/thesis.m'); addpath('./lib');
load('../../data/channels/channels.mat');

pmr_bl = pmr_best_offset(p_norm.nel2);

run_sweeps = true;
if run_sweeps
    N = 5;
    amps = zeros(N, 5);
    pmrs = zeros(N, 5);
    [amps(:, 2), pmrs(:, 2), ~, bitss] = delay_sweep(p_norm.nel2, p_norm.t, 2, N);
    [amps(:, 3), pmrs(:, 3), ~, bitss] = delay_sweep(p_norm.nel2, p_norm.t, 3, N);
    [amps(:, 4), pmrs(:, 4), ~, bitss] = delay_sweep(p_norm.nel2, p_norm.t, 4, N);
    [amps(:, 5), pmrs(:, 5), ~, bitss] = delay_sweep(p_norm.nel2, p_norm.t, 5, N);
    save('bit_res_sweep.mat');
else
    load('bit_res_sweep.mat');
end

figure;
subplot(211);
plot(bitss, pmrs(:, 3)/pmr_bl, '-k', 'linewidth', 2); hold all;
plot(bitss, pmrs(:, 4)/pmr_bl, '--', 'color', stanford_red, 'linewidth', 2); hold all;
plot(bitss, pmrs(:, 5)/pmr_bl, 'o-', 'color', new_blue, 'linewidth', 2); hold all;
xlabel('x1', 'fontsize', 14); 
ylabel('y1', 'fontsize', 14); 
ylim([1, 4])
set(gca, 'fontsize', 12);

subplot(212);
plot(bitss, amps(:, 3), '-k', 'linewidth', 2); hold all;
plot(bitss, amps(:, 4), '--', 'color', stanford_red, 'linewidth', 2); hold all;
plot(bitss, amps(:, 5), 'o-', 'color', new_blue, 'linewidth', 2); hold all;
xlabel('x2', 'fontsize', 14); 
ylabel('y2', 'fontsize', 14); 
ylim([0, 1])
set(gca, 'fontsize', 12);

print('-depsc', './figures/bit_res_sweep');

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
    c = brute_force_pmr_opt(ps, bits, 0.2);
%     disp(c);
    amp(k) = max(ps*c);
    pmr(k) = pmr_best_offset(ps*c);
end

end