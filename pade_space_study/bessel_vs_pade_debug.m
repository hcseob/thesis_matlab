function bessel_vs_pade_debug
addpath('./lib');
run('~/thesis/matlab/thesis.m');
load('../../data/channels/channels.mat');

pmr_bl = pmr_best_offset(p_norm.nel2);
disp(1/pmr_bl);

run_sweeps = false;
if run_sweeps
    N = 20;
    [amp_bs1, pmr_bs1, c_bs1, delays] = delay_sweep(p_norm.nel2, p_norm.t, N, 'bs1');
    [amp_pd1, pmr_pd1, c_pd1, delays] = delay_sweep(p_norm.nel2, p_norm.t, N, 'pd1');
    [amp_id, pmr_id, c_id, delays] = delay_sweep(p_norm.nel2, p_norm.t, N, 'ideal');
    save('bessel_vs_pade_debug.mat');
else
    load('bessel_vs_pade_debug.mat');
end

figure;
p7 = plot(delays/1e-12, pmr_id/pmr_bl, '-k', 'linewidth', 3); hold all;
p1 = plot(delays/1e-12, pmr_bs1/pmr_bl, '-k', 'color', new_blue, 'linewidth', 2); hold all;
p4 = plot(delays/1e-12, pmr_pd1/pmr_bl, '-', 'color', stanford_red, 'linewidth', 2); hold all;
plot([1, 1]*30, [1, 4], ':', 'color', 'k', 'linewidth', 1); hold all;

xlabel('Delay Time (ps)', 'fontsize', 18); 
ylabel('DR Improvement', 'fontsize', 18); 
set(gca, 'fontsize', 18);
ylim([1, 4]);
legend([p1, p4, p7], {'Bessel', 'Pade', 'Ideal'});

A0 = create_A(3, 0);
A1 = create_A(3, 1);
M0 = A0^(-1)*A1;
k = 9;
disp(delays(k)/1e-12);

disp(c_bs1(:, k));
disp(c_pd1(:, k));
disp(M0*c_pd1(:, k));

end

function [amp, pmr, c, delays] = delay_sweep(pulse, t, N, delay_type)
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