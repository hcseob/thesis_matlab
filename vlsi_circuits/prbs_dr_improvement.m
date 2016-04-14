clear all; close all; run('~/thesis/matlab/thesis.m'); addpath('./lib');
L = 4*(2^7-1);
path_ben = '../../data/bench/20160117_huawei/';
eq_ben = pulse_from_h5([path_ben, 'prbs7_20in_eq_diff.h5'], L);
ch_ben = pulse_from_h5([path_ben, 'prbs7_20in_ch.h5'], L);

%%
figure; hold all;
plot(ch_ben.t, ch_ben.ps, '-k');
plot(ch_ben.t, ch_ben.p, '-b');

figure; hold all;
plot(eq_ben.t, eq_ben.ps, '-k');
plot(eq_ben.t, eq_ben.p, '-b');

%%
ch = ch_ben.p-(max(ch_ben.p)+min(ch_ben.p))/2;
ch = ch/max(ch);
t = ch_ben.t;

eq = eq_ben.p-(max(eq_ben.p)+min(eq_ben.p))/2;
eq = eq/max(eq);
corr2max = 0;
for k = 1:L
    corr2current = abs(corr2(ch, circshift(eq, k)));
    if corr2current > corr2max
        eq_opt = circshift(eq, k);
        corr2max = corr2current;
    end
end
eq = -eq_opt;


dr_imp = 2.07;
figure; hold all;
plot(t, ch, '-k', 'linewidth', 2);
plot(t, eq/dr_imp, '-b', 'linewidth', 2);
plot([t(1), t(end)], [-1, -1], '--k');
plot([t(1), t(end)], [1, 1], '--k');
plot([t(1), t(end)], [-1, -1]/dr_imp, '--b');
plot([t(1), t(end)], [1, 1]/dr_imp, '--b');
ylim([-1.1, 1.1]);

%%
