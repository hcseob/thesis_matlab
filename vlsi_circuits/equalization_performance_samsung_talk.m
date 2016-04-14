clear all; close all; run('~/thesis/matlab/thesis.m'); addpath('./lib');

%% load data
% measurement (bench)
L = 4*128;
path_ben = '../../data/bench/20160117_huawei/';
eq_ben = pulse_from_h5([path_ben, 'pulse20in_eq.h5'], L);
c1_ben = pulse_from_h5([path_ben, 'pulse20in_c1.h5'], L);
ch_ben = pulse_from_h5([path_ben, 'pulse20in_ch.h5'], L);
ch_ben28 = pulse_from_h5([path_ben, 'pulse28in.h5'], L);

eqd_ben = pulse_from_h5([path_ben, 'pulse20in_eq_diff.h5'], L);
c1d_ben = pulse_from_h5([path_ben, 'pulse20in_c1_diff.h5'], L);


%% noise
figure; hold all;
offset = c1_ben.p(1);
plot(c1_ben.t/1e-9, (c1_ben.ps-offset)/1e-3, '-k');
plot(c1_ben.t/1e-9, (c1_ben.p-offset)/1e-3, '-', 'linewidth', 4, 'color', stanford_red);
xlim([0, 6]);
ylim([-30, 60]);
xlabel('Time [ns]', 'fontsize', 18);
ylabel('Voltage [mV]', 'fontsize', 18);
print('-dpng', './figures/noise_and_ave_single');

figure; hold all;
offset = c1d_ben.p(1);
plot(c1d_ben.t/1e-9, (c1d_ben.ps-offset)/1e-3, '-k');
plot(c1d_ben.t/1e-9, (c1d_ben.p-offset)/1e-3, '-', 'linewidth', 4, 'color', stanford_red);
xlim([0, 6]);
ylim([-30, 60]);
xlabel('Time [ns]', 'fontsize', 18);
ylabel('Voltage [mV]', 'fontsize', 18);
% print('-dpng', './figures/noise_and_ave_diff');

%%
noise_d = reshape(c1d_ben.ps, [8e6, 1]);
noise = reshape(c1_ben.ps, [8e6, 1]);
figure; plot(noise);

%% single-ended case
figure; hold all;
offset = 3040; pmr_range = 61:72;
p1 = plot(c1_ben.t/1e-12 - offset, c1_ben.p_norm, '-', 'linewidth', 3, 'color', 'k');
plot(c1_ben.t_baud(pmr_range)/1e-12 - offset, c1_ben.p_baud(pmr_range), 'o', 'linewidth', 3, 'color', 'k');
c1_ben.pmr = 1/sum(abs(c1_ben.p_baud(pmr_range)));

offset = 3002.5; pmr_range = 61:72;
p2 = plot(eq_ben.t/1e-12 - offset, eq_ben.p_norm, '-', 'linewidth', 3, 'color', stanford_red);
plot(eq_ben.t_baud(pmr_range)/1e-12 - offset, eq_ben.p_baud(pmr_range), 'o', 'linewidth', 3, 'color', stanford_red);
eq_ben.pmr = 1/sum(abs(eq_ben.p_baud(pmr_range)));
disp(['pmr ratio (single-ended) = ', num2str(eq_ben.pmr/c1_ben.pmr)]);

xlim([0, 600]);
xlabel('Time [ps]', 'fontsize', 18);
ylabel('Normalized Pulse', 'fontsize', 18);
% title(['PMR_{ch}=', num2str(c1_ben.pmr), ' and PMR_{eq}=', num2str(eq_ben.pmr)], 'fontsize', 18);
legend([p1, p2], {'Channel', 'Equalized'});
set(gca, 'fontsize', 14);
print('-depsc', './figures/bench_chandeq_singleended');


%% diff case
figure; hold all;
offset = 3040; pmr_range = 62:70;
p1 = plot(c1d_ben.t/1e-12 - offset, c1d_ben.p_norm, '-', 'linewidth', 2, 'color', 'k');
plot(c1d_ben.t_baud(pmr_range)/1e-12 - offset, c1d_ben.p_baud(pmr_range), 'o', 'linewidth', 2, 'color', 'k');
c1d_ben.pmr = 1/sum(abs(c1d_ben.p_baud(pmr_range)));

offset = 3027.5; pmr_range = 2+62*4:4:71*4;
p2 = plot(eqd_ben.t/1e-12 - offset, eqd_ben.p_norm, '-', 'linewidth', 2, 'color', stanford_red);
% plot(eqd_ben.t_baud/1e-12 - offset, eqd_ben.p_baud, 'o', 'linewidth', 2, 'color', stanford_red);
plot(eqd_ben.t(pmr_range)/1e-12 - offset, eqd_ben.p_norm(pmr_range), 'o', 'linewidth', 2, 'color', stanford_red);
eqd_ben.pmr = 1/sum(abs(eqd_ben.p_norm(pmr_range)));
disp(['pmr ratio (pseudo-diff) = ', num2str(eqd_ben.pmr/c1d_ben.pmr)]);

xlim([0, 750]);
xlabel('Time [ps]', 'fontsize', 18);
ylabel('Normalized Pulse', 'fontsize', 18);
title(['PMR_{ch}=', num2str(c1d_ben.pmr), ' and PMR_{eq}=', num2str(eqd_ben.pmr)], 'fontsize', 18);
legend([p1, p2], {'Channel (FFE out c1=1)', 'Equalized'});
set(gca, 'fontsize', 14);
print('-depsc', './figures/bench_chandeq_diff');