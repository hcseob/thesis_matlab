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

delays = logspace(0, 2, 40)*1e-12;
for m = 1:length(delays)
    % create delay pulse family
    delay = delays(m);
    delay_cell = pade_sys(1, delay);
    clear ps;
    for j = 1:num_taps
        ps(:, j) = lsim((delay_cell*rc)^(j-1)*rc^2, pulse, t);
    end
    
    coeffs_nothresh = brute_force_pmr_opt(ps, bits, 0);
    ampls_nothresh(m) = max(ps*coeffs_nothresh); 
    pmr_opts_nothresh(m) = pmr_best_offset(ps, coeffs_nothresh);

    % find opt pmr
    coeffs = brute_force_pmr_opt(ps, bits, threshold);
    ampls(m) = max(ps*coeffs); 
    pmr_opts(m) = pmr_best_offset(ps, coeffs);
end

%%
figure;
subplot(211);
semilogx(delays/1e-12, pmr_opts, '-k', 'linewidth', 2); hold all;
semilogx(delays/1e-12, pmr_opts_nothresh, '-k');
semilogx(delays/1e-12, ones(size(delays))*pmr_ch, '--k'); hold all;

xlabel('Delay Time [ps]');
ylabel('PMR');

ampls(1:15) = threshold;
subplot(212);
semilogx(delays, ampls, '-k', 'linewidth', 2); hold all;
semilogx(delays, ampls_nothresh, '-k');
xlabel('Delay Time [ps]');
ylabel('Main Cursor Scale');
print('-depsc', './figures/one_tap_delay_sweep');
%%
figure; hold all;
plot(ps*coeffs);
plot(ps(:, 1)*coeffs(1))
plot(ps(:, 2)*coeffs(2))


