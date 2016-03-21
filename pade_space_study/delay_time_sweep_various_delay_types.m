function delay_time_sweep_various_delay_types
run('~/thesis/matlab/thesis.m');
load('../../data/channels/channels.mat');

pmr_bl = pmr_best_offset(p_norm.nel2);

run_sweeps = false;
if run_sweeps
    N = 20;
    amps = zeros(N, 5);
    pmrs = zeros(N, 5);
    [amps(:, 2), pmrs(:, 2), c2, delays] = delay_sweep(p_norm.nel2, p_norm.t, N, 'bs1');
    [amps(:, 3), pmrs(:, 3), c3, delays] = delay_sweep(p_norm.nel2, p_norm.t, N, 'bs2');
    [amps(:, 4), pmrs(:, 4), c4, delays] = delay_sweep(p_norm.nel2, p_norm.t, N, 'pd1');
    [amps(:, 5), pmrs(:, 5), c5, delays] = delay_sweep(p_norm.nel2, p_norm.t, N, 'pd2');
    [amps(:, 6), pmrs(:, 6), c6, delays] = delay_sweep(p_norm.nel2, p_norm.t, N, 'ideal');
    save('delay_time_sweep_various_delay_types.mat');
else
    load('delay_time_sweep_various_delay_types.mat');
end

figure;
subplot(211); hold all;
semilogx(delays/1e-12, pmrs(:, 2)/pmr_bl, '-k', 'linewidth', 2); hold all;
semilogx(delays/1e-12, pmrs(:, 3)/pmr_bl, '--', 'color', stanford_red, 'linewidth', 2); hold all;
semilogx(delays/1e-12, pmrs(:, 4)/pmr_bl, ':', 'color', new_blue, 'linewidth', 2); hold all;
semilogx(delays/1e-12, pmrs(:, 5)/pmr_bl, '-o', 'color', new_blue, 'linewidth', 2); hold all;
semilogx(delays/1e-12, pmrs(:, 6)/pmr_bl, '-x', 'color', new_blue, 'linewidth', 2); hold all;
xlabel('Delay Time [ps]', 'fontsize', 14); 
ylabel('DR Improvement', 'fontsize', 14); 
set(gca, 'fontsize', 14);
ylim([1, 4]);
subplot(212);
semilogx(delays/1e-12, amps(:, 2), '-k', 'linewidth', 2); hold all;
semilogx(delays/1e-12, amps(:, 3), '--', 'color', stanford_red, 'linewidth', 2); hold all;
semilogx(delays/1e-12, amps(:, 4), ':', 'color', new_blue, 'linewidth', 2); hold all;
semilogx(delays/1e-12, amps(:, 5), '-o', 'color', new_blue, 'linewidth', 2); hold all;
semilogx(delays/1e-12, amps(:, 6), '-x', 'color', new_blue, 'linewidth', 2); hold all;
xlabel('Delay Time [ps]', 'fontsize', 14); 
ylabel('Attenuation', 'fontsize', 14); 
set(gca, 'fontsize', 14);
ylim([0, 1.5]);
save_fig('./figures/delay_time_sweep_various_delay_types.eps');

%%
% num_taps = 5;
% delay = 14e-12;
% pulse = p_norm.nel2;
% t = p_norm.t;
% ps = ideal_delay(pulse, delay, num_taps);
% figure;
% plot(t, ps);

end

function [amp, pmr, c, delays] = delay_sweep(pulse, t, N, delay_type)
bits = 4;
num_taps = 4;
delays = logspace(0, 2, N)*1e-12;
for k = 1:length(delays)
    disp(k);
    delay = delays(k);
    
    if strcmp(delay_type, 'ideal')
        ps = ideal_delay(pulse, delay, num_taps);
    else
        order = str2double(delay_type(3));
        if strcmp(delay_type(1:2), 'pd')
            delay_cell = pade_sys(order, delay);
        elseif strcmp(delay_type(1:2), 'bs')
            delay_cell = bessel_sys(order, delay);
        end

        for j = 1:num_taps
            ps(:, j) = lsim((delay_cell)^(j-1), pulse, t);
        end
    end
    c(:, k) = brute_force_pmr_opt(ps, bits, 1.0);
    amp(k) = max(ps*c(:, k));
    pmr(k) = pmr_best_offset(ps*c(:, k));
end

end

function ps = ideal_delay(pulse, delay, num_taps)
    delay_int = round(delay/1e-12);
    ps(:, 1) = pulse;
    for j = 2:num_taps
        ps(:, j) = [zeros(1, delay_int*(j-1)), pulse(1:end-delay_int*(j-1))];
    end
end