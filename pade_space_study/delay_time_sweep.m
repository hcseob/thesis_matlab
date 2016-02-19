clear all; close all; run('~/thesis/matlab/thesis.m'); addpath('./lib');

% load channel and calc pmr
load('./nelco_pulse.mat');
for offset = 1:50
    p = pulse(1+offset:50:end);
    pmr(offset) = max(p)/sum(abs(p));
end
pmr_ch = max(pmr);

%% PMR sweep
% BW = 20e9;
% rc = tf([1], [1/2/pi/BW, 1]);
rc = 1;

threshold = 0.2;
bits = 7;
num_taps = 2;

for k = 1:3
    delay_cells{k} = pade_sys(k, delay);
    delay_cells{k+3} = bessel_sys(k, delay);
end

delays = logspace(0, 2, 40)*1e-12;
for n = 1:length(delay_cells)
    for m = 1:length(delays)
        % create delay pulse family
        delay = delays(m);
        delay_cell = delay_cells{n};
        clear ps;
        for j = 1:num_taps
            ps(:, j) = lsim((delay_cell*rc)^(j-1)*rc^2, pulse, t);
        end
        
        coeffs_nothresh = brute_force_pmr_opt(ps, bits, 0);
        ampls_nothresh(m, n) = max(ps*coeffs_nothresh);
        pmr_opts_nothresh(m, n) = pmr_best_offset(ps, coeffs_nothresh);
        
        % find opt pmr
        coeffs = brute_force_pmr_opt(ps, bits, threshold);
        ampls(m, n) = max(ps*coeffs);
        pmr_opts(m, n) = pmr_best_offset(ps, coeffs);
    end
end
%%
figure;
subplot(211);
semilogx(delays/1e-12, pmr_opts(:, 1), '-k', 'linewidth', 2); hold all;
semilogx(delays/1e-12, pmr_opts_nothresh(:, 1), '-k');
semilogx(delays/1e-12, ones(size(delays))*pmr_ch, '--k'); hold all;

xlabel('Delay Time [ps]');
ylabel('PMR');

ampls(1:15, :) = threshold;
subplot(212);
semilogx(delays, ampls(:, 1), '-k', 'linewidth', 2); hold all;
semilogx(delays, ampls_nothresh(:, 1), '-k');
xlabel('Delay Time [ps]');
ylabel('Main Cursor Scale');
print('-depsc', './figures/one_tap_delay_sweep');
%%
figure; hold all;
plot(ps*coeffs);
plot(ps(:, 1)*coeffs(1))
plot(ps(:, 2)*coeffs(2))


