function delay_time_sweep_various_delay_types
addpath('./lib');
run('~/thesis/matlab/thesis.m');
load('../../data/channels/channels.mat');

pmr_bl = pmr_best_offset(p_norm.nel2);

run_sweeps = false;
if run_sweeps
    N = 20;
    [amp_bs1, pmr_bs1, c_bs1, delays] = delay_sweep(p_norm.nel2, p_norm.t, N, 'bs1');
    [amp_bs2, pmr_bs2, c_bs2, delays] = delay_sweep(p_norm.nel2, p_norm.t, N, 'bs2');
    [amp_bs3, pmr_bs3, c_bs3, delays] = delay_sweep(p_norm.nel2, p_norm.t, N, 'bs3');
    [amp_pd1, pmr_pd1, c_pd1, delays] = delay_sweep(p_norm.nel2, p_norm.t, N, 'pd1');
    [amp_pd2, pmr_pd2, c_pd2, delays] = delay_sweep(p_norm.nel2, p_norm.t, N, 'pd2');
    [amp_pd3, pmr_pd3, c_pd3, delays] = delay_sweep(p_norm.nel2, p_norm.t, N, 'pd3');
    [amp_id, pmr_id, c_id, delays] = delay_sweep(p_norm.nel2, p_norm.t, N, 'ideal');
    save('delay_time_sweep_various_delay_types.mat');
else
    load('delay_time_sweep_various_delay_types.mat');
end

figure;
plot(delays/1e-12, pmr_bs1/pmr_bl, '-k', 'linewidth', 2); hold all;
plot(delays/1e-12, pmr_bs2/pmr_bl, '--k', 'linewidth', 2); hold all;
plot(delays/1e-12, pmr_bs3/pmr_bl, ':k', 'linewidth', 2); hold all;
plot(delays/1e-12, pmr_pd1/pmr_bl, '-', 'color', stanford_red, 'linewidth', 2); hold all;
plot(delays/1e-12, pmr_pd2/pmr_bl, '--', 'color', stanford_red, 'linewidth', 2); hold all;
plot(delays/1e-12, pmr_pd3/pmr_bl, ':', 'color', stanford_red, 'linewidth', 2); hold all;
plot(delays/1e-12, pmr_id/pmr_bl, '-k', 'linewidth', 3); hold all;
xlabel('Delay Time [ps]', 'fontsize', 18); 
ylabel('DR Improvement', 'fontsize', 18); 
set(gca, 'fontsize', 18);
ylim([1, 4]);

save_fig('./figures/delay_time_sweep_various_delay_types.eps');

plot_amps = false;
if plot_amps
    figure;
    plot(delays/1e-12, amp_bs1, '-k', 'linewidth', 2); hold all;
    plot(delays/1e-12, amp_bs2, '--k', 'linewidth', 2); hold all;
    plot(delays/1e-12, amp_bs3, ':k', 'linewidth', 2); hold all;
    plot(delays/1e-12, amp_pd1, '-', 'color', stanford_red, 'linewidth', 2); hold all;
    plot(delays/1e-12, amp_pd2, '--', 'color', stanford_red, 'linewidth', 2); hold all;
    plot(delays/1e-12, amp_pd3, ':', 'color', stanford_red, 'linewidth', 2); hold all;
    plot(delays/1e-12, amp_id, '-', 'color', new_blue, 'linewidth', 4); hold all;
    xlabel('Delay Time [ps]', 'fontsize', 14); 
    ylabel('Attenuation', 'fontsize', 14); 
    set(gca, 'fontsize', 14);
    % ylim([0, 1.5]);
end
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
% bits = 5;
num_taps = 3;
atten = 0.5;
delays = logspace(1, 2, N)*1e-12;
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
%     c(:, k) = brute_force_pmr_opt(ps, bits, atten);
    c(:, k) = optim_pmr_opt(ps, atten);
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