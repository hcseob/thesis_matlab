clear all; close all; run('~/thesis/matlab/thesis.m'); addpath('./lib');

%% load data
% measurement (bench)
L = 4*128;
path_ben = '../../data/bench/20160117_huawei/';
eq_ben = pulse_from_h5([path_ben, 'pulse20in_eq.h5'], L);
c1_ben = pulse_from_h5([path_ben, 'pulse20in_c1.h5'], L);


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
disp(['pmr ratio (single-ended) = ', num2str(eq_ben.pmr)]);
disp(['pmr ratio (single-ended) = ', num2str(c1_ben.pmr)]);

xlim([0, 600]);
ylim([-0.1, 1.1]);
xlabel('Time (ps)', 'fontsize', 18);
ylabel('Normalized Pulse', 'fontsize', 18);
% title(['PMR_{ch}=', num2str(c1_ben.pmr), ' and PMR_{eq}=', num2str(eq_ben.pmr)], 'fontsize', 18);
legend([p1, p2], {'Channel', 'Equalized'});
set(gca, 'fontsize', 18);
box on;
save_fig('./figures/dr_improvement.eps');


%%
p_ch = c1_ben.p_baud(61:80);
p_eq = eq_ben.p_baud(61:80);

figure; hold all;
plot(p_eq, '-ok');
plot(p_ch, '-or');

[sum(abs(p_eq)), sum(abs(p_ch)), sum(abs(p_ch))/sum(abs(p_eq))]

%%
p_ch_unnorm = c1_ben.p - c1_ben.p(1);
p_eq_unnorm = eq_ben.p - eq_ben.p(1);

figure; hold all;
plot(p_ch_unnorm); 
plot(p_eq_unnorm);

2*max(p_ch_unnorm)/max(p_eq_unnorm)