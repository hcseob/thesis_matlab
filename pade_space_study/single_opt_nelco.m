clear all; close all; run('~/thesis/matlab/thesis.m'); addpath('./lib');

% load channel and calc pmr
load('./nelco_pulse.mat');
for offset = 1:50
    p = pulse(1+offset:50:end);
    pmr(offset) = max(p)/sum(abs(p));
end
pmr_ch = max(pmr);

% delay sys
pd1 = pade_sys(1, 25e-12);
pd2 = pade_sys(2, 25e-12);
pd3 = pade_sys(3, 25e-12);
bs1 = bessel_sys(1, 25e-12);
bs2 = bessel_sys(2, 25e-12);
bs3 = bessel_sys(3, 25e-12);

%% PMR sweep

threshold = 0;
bits = 5;
num_taps = [2, 3, 4, 5];
BWs = logspace(9, 11, 10);

for m = 1:length(num_taps)
    for k = 1:length(BWs)
        BW = BWs(k);
        rc = tf([1], [1/2/pi/BW, 1]);
        % create delay pulse family
        clear ps;
        for j = 1:num_taps(m)
            ps(:, j) = lsim((bs3*rc)^(j-1)*rc^2, pulse, t);
        end
        
        % find opt pmr
        [coeffs_opt, pmr_opt, p_opt] = brute_force_pmr_opt(ps, bits, threshold);
        ampls(k, m) = max(p_opt);
%         coeffs_opts(:, k, m) = coeffs_opt;   

        % find best offset for pmr
        for offset = 1:50
            ps_baud = ps(1+offset:50:end, :);
            p = ps_baud*coeffs_opt;
            pmr(offset) = max(p)/sum(abs(p));
        end
        pmr_opts(k, m) = max(pmr);
    end
end



%%
load('BW_sweep_dump.mat');
figure;
semilogx(BWs, pmr_opts(:, 1), '-k', 'linewidth', 2); hold all;
semilogx(BWs, pmr_opts(:, 2), '-', 'linewidth', 2, 'color', new_blue);
semilogx(BWs, pmr_opts(:, 3), '-', 'linewidth', 2, 'color', stanford_red);
semilogx(BWs, pmr_opts(:, 4), '-b', 'linewidth', 2);
plot(BWs, ones(size(BWs))*pmr_ch, '--k');


