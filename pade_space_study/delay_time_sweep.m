clear all; close all; run('~/thesis/matlab/thesis.m'); addpath('./lib');

% load channel and calc pmr
load('./nelco_pulse.mat');
for offset = 1:50
    p = pulse(1+offset:50:end);
    pmr(offset) = max(p)/sum(abs(p));
end
pmr_ch = max(pmr);

%% PMR sweep
rcs{1} = 1;
BW = 10e9;
rcs{2} = tf([1], [1/2/pi/BW, 1]);
BW = 5e9;
rcs{3} = tf([1], [1/2/pi/BW, 1]);

threshold = 0.2;
bits = 7;
num_taps = 2;
ffe_sys_nothresh = {};
ffe_sys = {};
delays = logspace(0, 2, 40)*1e-12;
for l = 1:length(rcs)
    for n = 1:6
        for m = 1:length(delays)
            % create delay pulse family
            delay = delays(m);
            if n <= 3
                delay_cell = pade_sys(n, delay);
            else
                delay_cell = bessel_sys(n-3, delay);
            end
            rc = rcs{l};
            clear ps;
            for j = 1:num_taps
                ps(:, j) = lsim((delay_cell*rc)^(j-1)*rc^2, pulse, t);
            end

            coeffs_nothresh = brute_force_pmr_opt(ps, bits, 0);
            ampls_nothresh(m, n, l) = max(ps*coeffs_nothresh);
            pmr_opts_nothresh(m, n, l) = pmr_best_offset(ps, coeffs_nothresh);
            ffe_sys_nothresh{m, n, l} = 0;
            for j = 1:length(coeffs_nothresh)
                ffe_sys_nothresh{m, n, l} = ffe_sys_nothresh{m, n, l} + coeffs_nothresh(j)*(delay_cell*rc)^(j-1)*rc^2;
            end
            
            % find opt pmr
            coeffs = brute_force_pmr_opt(ps, bits, threshold);
            
            ffe_sys{m, n, l} = 0;
            for j = 1:length(coeffs_nothresh)
                ffe_sys{m, n, l} = ffe_sys{m, n, l} + coeffs(j)*(delay_cell*rc)^(j-1)*rc^2;
            end
            
            ampls(m, n, l) = max(ps*coeffs);
            pmr_opts(m, n, l) = pmr_best_offset(ps, coeffs);
            
        end
    end
end
%%
plot_figures = false;
if plot_figures
    delay_types = {'pade1', 'pade2', 'pade3', 'bessel1', 'bessel2', 'bessel3'};
    BWs = {'BWeqInf', 'BWeq10G', 'BWeq5G'};
    for l = 1:length(BWs)
        for n = 1:6
            figure;
            subplot(211);
            semilogx(delays/1e-12, pmr_opts(:, n, l), '-k', 'linewidth', 2); hold all;
            semilogx(delays/1e-12, pmr_opts_nothresh(:, n, l), '-k');
            semilogx(delays/1e-12, ones(size(delays))*pmr_ch, '--k'); hold all;

            xlabel('Delay Time [ps]');
            ylabel('PMR');
            ylim([0, 0.5]);

    %         ampls(1:15, :) = threshold;
            subplot(212);
            semilogx(delays, ampls(:, n, l), '-k', 'linewidth', 2); hold all;
            semilogx(delays, ampls_nothresh(:, n, l), '-k');
            xlabel('Delay Time [ps]');
            ylabel('Main Cursor Scale');
            ylim([0, 1]);
            print('-depsc', ['./figures/one_tap_delay_sweep_', delay_types{n}, '_', BWs{l}]);
        end
    end
end
%%
figure; hold all;
plot(ps*coeffs);
plot(ps(:, 1)*coeffs(1))
plot(ps(:, 2)*coeffs(2))


%%
figure; 
for m = 1:length(delays)/10
    bode(ffe_sys_nothresh{m*10, 1, 1}); hold all;
end
