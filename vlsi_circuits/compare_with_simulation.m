clear all; close all; run('~/thesis/matlab/thesis.m'); addpath('./lib');

%% load data
% simulation
path_sim = '../../data/simulation/nelco/';
[ch_sim, eq_sim] = pulse_from_csv_sim([path_sim, 'pulse_resp_huawei.csv']);
[c1_sim, ~] = pulse_from_csv_sim([path_sim, 'pulse_family_huawei.csv']);

% measurement (bench)
L = 4*128;
path_ben = '../../data/bench/20160117_huawei/';
eq_ben = pulse_from_h5([path_ben, 'pulse20in_eq.h5'], L);
c1_ben = pulse_from_h5([path_ben, 'pulse20in_c1.h5'], L);
ch_ben = pulse_from_h5([path_ben, 'pulse20in_ch.h5'], L);
ch_ben28 = pulse_from_h5([path_ben, 'pulse28in.h5'], L);

% ch_sim.pmr = 1/sum(abs(ch_sim.p_norm));

%% 20" versus 28"
figure; hold all;
offset = 3000;
p1 = plot(ch_ben.t/1e-12 - offset, ch_ben.p_norm, '-', 'linewidth', 3, 'color', 'k');
plot(ch_ben.t_baud/1e-12 - offset, ch_ben.p_baud, 'o', 'linewidth', 2, 'color', 'k', 'markerfacecolor', 'k', 'markersize', 8);

offset = 2930;
p2 = plot(ch_ben28.t/1e-12 - offset, ch_ben28.p_norm, '-', 'linewidth', 3, 'color', stanford_red);
plot(ch_ben28.t_baud/1e-12 - offset, ch_ben28.p_baud, 'o', 'linewidth', 2, 'color', stanford_red, 'markerfacecolor', stanford_red, 'markersize', 8);
xlim([0, 750]);
ylim([-0.2, 1.2]);
xlabel('Time [ps]', 'fontsize', 18);
ylabel('Normalized Pulse', 'fontsize', 18);
legend([p1, p2], {'Channel (20")', 'Channel (28")'});
set(gca, 'fontsize', 14);
save_fig('./figures/huawei_28and20in.eps');

%% channel sim and through c1
figure; hold all;
offset = 555;
p1 = plot(ch_sim.t/1e-12 - offset, ch_sim.p_norm, '-', 'linewidth', 3, 'color', 'k');
plot(ch_sim.t_baud/1e-12 - offset, ch_sim.p_baud, 'o', 'linewidth', 2, 'color', 'k', 'markerfacecolor', 'k', 'markersize', 8);

offset = 555;
p2 = plot(c1_sim.t/1e-12 - offset, c1_sim.p_norm, '-', 'linewidth', 3, 'color', stanford_red);
plot(c1_sim.t_baud/1e-12 - offset, c1_sim.p_baud, 'o', 'linewidth', 2, 'color', stanford_red, 'markerfacecolor', stanford_red, 'markersize', 8);
xlim([0, 750]);
ylim([-0.2, 1.2]);
xlabel('Time [ps]', 'fontsize', 18);
ylabel('Normalized Pulse', 'fontsize', 18);
legend([p1, p2], {'Sim FFE Input (28" Ch)', 'Sim FFE Output (c1=1)'});
set(gca, 'fontsize', 14);
print('./figures/huawei_28in_sim_chandc1.eps');

%% channel bench and through c1
figure; hold all;
offset = 3000;
p1 = plot(ch_ben.t/1e-12 - offset, ch_ben.p_norm, '-k', 'linewidth', 3);
plot(ch_ben.t_baud/1e-12 - offset, ch_ben.p_baud, 'ok', 'linewidth', 2, 'markerfacecolor', 'k', 'markersize', 8);
p2 = plot(c1_ben.t/1e-12 - offset, c1_ben.p_norm, '-', 'linewidth', 3, 'color', stanford_red);
plot(c1_ben.t_baud/1e-12 - offset, c1_ben.p_baud, 'o', 'linewidth', 2, 'color', stanford_red, 'markerfacecolor', stanford_red, 'markersize', 8);

xlim([0, 750]);
ylim([-0.2, 1.2]);
legend([p1, p2], {'Bench Channel (20")', 'Bench FFE Output (c1=1)'});
xlabel('Time [ps]', 'fontsize', 18);
ylabel('Normalized Pulse', 'fontsize', 18);
% title(['PMR_{ch}=', num2str(pmr_ch), ' and PMR_{eq}', num2str(pmr_eq)], 'fontsize', 18);
set(gca, 'fontsize', 14);
save_fig('./figures/huawei_20in_ben_chandc1.eps');

%%
% offset = 555;
% p1 = plot(c1_sim.t/1e-12 - offset, c1_sim.p_norm, '-k', 'linewidth', 2);
% plot(c1_sim.t_baud/1e-12 - offset, c1_sim.p_baud, 'ok', 'linewidth', 2);
% 
% offset = 2925;
% p2 = plot(ch_ben28.t/1e-12 - offset, ch_ben28.p_norm, '-', 'linewidth', 2, 'color', new_blue);
% plot(ch_ben28.t_baud/1e-12 - offset, ch_ben28.p_baud, 'o', 'linewidth', 2, 'color', new_blue);

