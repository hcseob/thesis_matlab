clear all; close all; run('~/thesis/matlab/thesis.m'); addpath('./lib');

L = 4*128;
path_ben = '../../data/bench/20160117_huawei/';
eq_ben = pulse_from_h5([path_ben, 'pulse20in_eq.h5'], L);
c1_ben = pulse_from_h5([path_ben, 'pulse20in_c1.h5'], L);

% figure; hold all;
offset = 3000;
% p1 = plot(c1_ben.t/1e-12 - offset, c1_ben.p_norm, '-', 'linewidth', 2, 'color', 'k');
% plot(c1_ben.t_baud/1e-12 - offset, c1_ben.p_baud, 'o', 'linewidth', 2, 'color', 'k');
% xlim([0, 1500]);

%%
t = (0:12.5e-12:30000e-12);
ch = interp1(c1_ben.t - offset*1e-12, c1_ben.p_norm, t, 'spline', 0);
eq = interp1(eq_ben.t - offset*1e-12, eq_ben.p_norm, t, 'spline', 0);

N = 50; C = 10; rng(1)
prbs = [round(rand(N, 1))*2 - 1; ...
        ones(C, 1); ...
        round(rand(N, 1))*2 - 1; ...
        -ones(C, 1); ...
        round(rand(N, 1))*2 - 1];

eq_prbs = zeros(size(eq));
ch_prbs = zeros(size(ch));
for k = 1:length(prbs)
    eq_prbs = eq_prbs + prbs(k)*circshift(eq, [0, 4*k]);
    ch_prbs = ch_prbs + prbs(k)*circshift(ch, [0, 4*k]);
end
ch_prbs = ch_prbs - (max(ch_prbs)+min(ch_prbs))/2;
eq_prbs = eq_prbs - (max(eq_prbs)+min(eq_prbs))/2;

t = t/1e-9;
figure; hold all;
plot(t, ch_prbs, '-k', 'linewidth', 3);
plot([t(1), t(end)], max(ch_prbs)*[1, 1], '--k', 'linewidth', 1);
plot([t(1), t(end)], min(ch_prbs)*[1, 1], '--k', 'linewidth', 1);

plot(t, eq_prbs, '-', 'linewidth', 3, 'color', stanford_red);
plot([t(1), t(end)], max(eq_prbs)*[1, 1], '--', 'linewidth', 1, 'color', stanford_red);
plot([t(1), t(end)], min(eq_prbs)*[1, 1], '--', 'linewidth', 1, 'color', stanford_red);
xlim([0, 8]);
ylim([-6, 6]);
xlabel('Time [ns]', 'fontsize', 18);
ylabel('Normalized PRBS', 'fontsize', 18);
set(gca, 'fontsize', 18);

save_fig('./figures/prbs_from_pulse.eps');

pmr_improvement = (max(ch_prbs) - min(ch_prbs))/(max(eq_prbs) - min(eq_prbs))
