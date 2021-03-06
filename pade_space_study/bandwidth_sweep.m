function bandwidth_sweep
run('~/thesis/matlab/thesis.m');
load('../../data/channels/channels.mat');

pmr_bl = pmr_best_offset(p_norm.nel2);

run_sweeps = false;
if run_sweeps
    N = 20;
    amps = zeros(N, 5);
    pmrs = zeros(N, 5);
%     [amps(:, 2), pmrs(:, 2), c2, BWs] = delay_sweep(p_norm.nel2, p_norm.t, 2, N);
    [amps(:, 3), pmrs(:, 3), c3, BWs] = delay_sweep(p_norm.nel2, p_norm.t, 3, N);
    [amps(:, 4), pmrs(:, 4), c4, BWs] = delay_sweep(p_norm.nel2, p_norm.t, 4, N, [c3; zeros(1, N)]);
    [amps(:, 5), pmrs(:, 5), c5, BWs] = delay_sweep(p_norm.nel2, p_norm.t, 5, N, [c4; zeros(1, N)]);
    save('BW_sweep.mat');
else
    load('BW_sweep.mat');
end

figure;
semilogx(BWs/1e9, pmrs(:, 3)/pmr_bl, '-k', 'linewidth', 3); hold all;
semilogx(BWs/1e9, pmrs(:, 4)/pmr_bl, '--', 'color', stanford_red, 'linewidth', 3); hold all;
semilogx(BWs/1e9, pmrs(:, 5)/pmr_bl, ':', 'color', new_blue, 'linewidth', 3); hold all;
semilogx([20, 20], [1, 4], ':', 'color', 'k', 'linewidth', 1); hold all;
xlabel('Bandwidth (GHz)', 'fontsize', 18); 
ylabel('DR Improvement', 'fontsize', 18); 
ylim([1, 4])
set(gca, 'fontsize', 18);
legend('n = 3', 'n = 4', 'n = 5', 'location', 'northwest');
save_fig('./figures/bandwidth_sweep.eps');

plot_amps = true;
if plot_amps
    figure;
    semilogx(BWs/1e9, amps(:, 3), '-k', 'linewidth', 2); hold all;
    semilogx(BWs/1e9, amps(:, 4), '--', 'color', stanford_red, 'linewidth', 2); hold all;
    semilogx(BWs/1e9, amps(:, 5), ':', 'color', new_blue, 'linewidth', 2); hold all;
    xlabel('Bandwidth [GHz]', 'fontsize', 18); 
    ylabel('Attenuation', 'fontsize', 18); 
    ylim([0, 1])
    set(gca, 'fontsize', 18);
end
end

function [amp, pmr, c, BWs] = delay_sweep(pulse, t, num_taps, N, c_inits)
if nargin < 5; c_inits = zeros(num_taps, N); end;
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
%     c(:, k) = brute_force_pmr_opt(ps, bits, 0.1);
    c(:, k) = optim_pmr_opt(ps, 0.5, c_inits(:, k));
%     disp(c);
    amp(k) = max(ps*c(:, k));
    pmr(k) = pmr_best_offset(ps*c(:, k));
end

end