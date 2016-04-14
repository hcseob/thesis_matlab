clear all; close all; run('~/thesis/matlab/thesis.m'); addpath('./lib');

L = 4*128;
%% differential case
path = '../../data/bench/20160117_huawei/';
eq_d = pulse_from_h5([path, 'pulse20in_eq_diff.h5'], L);
eq_c1_d = pulse_from_h5([path, 'pulse20in_c1_diff.h5'], L);
ch = pulse_from_h5([path, 'pulse20in_ch.h5'], L);

offset = 3000;
pmr_range = (62:75);
figure; hold all;
p1 = plot(eq_d.t/1e-12-offset, eq_d.p_norm, '-k', 'linewidth', 2);
plot(eq_d.t_baud(pmr_range)/1e-12-offset, eq_d.p_baud(pmr_range), 'ok', 'linewidth', 2);
p2 = plot(eq_c1_d.t/1e-12-offset, eq_c1_d.p_norm, '-', 'color', stanford_red, 'linewidth', 2);
plot(eq_c1_d.t_baud(pmr_range)/1e-12-offset, eq_c1_d.p_baud(pmr_range), 'o', 'color', stanford_red, 'linewidth', 2);
p3 = plot(ch.t/1e-12-offset, ch.p_norm, '-b', 'linewidth', 2);
plot(ch.t_baud(pmr_range)/1e-12-offset, ch.p_baud(pmr_range), 'ob', 'linewidth', 2);
xlim([0, 1000]);
xlabel('Time (ps)', 'fontsize', 18);
ylabel('Normalized Pulse Response', 'fontsize', 18);
legend([p1, p2, p3], {'Equalized', 'Coeff1', 'Channel'});
set(gca, 'fontsize', 18);

% calc pmr
ch.pmr = 1/sum(abs(ch.p_baud(pmr_range)));
eq_c1_d.pmr = 1/sumabs((eq_c1_d.p_baud(pmr_range)));
eq_d.pmr = 1/sum(abs(eq_d.p_baud(pmr_range)));
disp(db([eq_d.pmr/ch.pmr, eq_d.pmr/eq_c1_d.pmr]));

%% single-ended case
path = '../../data/bench/20160117_huawei/';
eq = pulse_from_h5([path, 'pulse20in_eq.h5'], L);
eq_c1 = pulse_from_h5([path, 'pulse20in_c1.h5'], L);
ch = pulse_from_h5([path, 'pulse20in_ch.h5'], L);

offset = 3000;
pmr_range = (62:75);
figure; hold all;
p1 = plot(eq.t/1e-12-offset, eq.p_norm, '-k', 'linewidth', 2);
plot(eq.t_baud(pmr_range)/1e-12-offset, eq.p_baud(pmr_range), 'ok', 'linewidth', 2);
p2 = plot(eq_c1.t/1e-12-offset, eq_c1.p_norm, '-', 'color', stanford_red, 'linewidth', 2);
plot(eq_c1.t_baud(pmr_range)/1e-12-offset, eq_c1.p_baud(pmr_range), 'o', 'color', stanford_red, 'linewidth', 2);
p3 = plot(ch.t/1e-12-offset, ch.p_norm, '-b', 'linewidth', 2);
plot(ch.t_baud(pmr_range)/1e-12-offset, ch.p_baud(pmr_range), 'ob', 'linewidth', 2);
xlim([0, 1000]);
xlabel('Time (ps)', 'fontsize', 18);
ylabel('Normalized Pulse Response', 'fontsize', 18);
legend([p1, p2, p3], {'Equalized', 'Coeff1', 'Channel'});
set(gca, 'fontsize', 18);

% calc pmr
ch.pmr = 1/sum(abs(ch.p_baud(pmr_range)));
eq_c1.pmr = 1/sumabs((eq_c1.p_baud(pmr_range)));
eq.pmr = 1/sum(abs(eq.p_baud(pmr_range)));
disp(db([eq.pmr/ch.pmr, eq.pmr/eq_c1.pmr]));