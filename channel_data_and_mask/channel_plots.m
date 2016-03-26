clear all; close all;
run('~/thesis/matlab/thesis.m'); addpath('./lib');

load('channels.mat');

figure; hold all;
plot(IL.f/1e9, -db(IL.nel0), '-', 'color', 'k', 'linewidth', 3);
plot(IL.f/1e9, -db(IL.nel2), '--', 'color', stanford_red, 'linewidth', 3);
plot(IL.f/1e9, -db(IL.ibm), ':', 'color', new_blue, 'linewidth', 3);
xlim([0, 15]);
ylim([0, 50]);
set(gca, 'fontsize', 18);
xlabel('Frequency (GHz)', 'fontsize', 18);
ylabel('Insertion Loss (dB)', 'fontsize', 18);
legend('0.76 m FR4 ref', '1.09 m FR4 ref', '1.0 m Meg ref');
axis ij;
box on;
save_fig('./figures/channel_plots_insertion_loss.eps');

%%
os = 1; T = 50;
t_baud = p_norm.t(os:T:end);
nel0_baud = p_norm.nel0(os:T:end);
nel2_baud = p_norm.nel2(os:T:end);
ibm_baud = p_norm.ibm(os:T:end);

figure; hold all;
plot(p_norm.t/1e-12, p_norm.nel0, '-', 'color', 'k', 'linewidth', 3);
plot(p_norm.t/1e-12, p_norm.nel2, '--', 'color', stanford_red, 'linewidth', 3);
plot(p_norm.t/1e-12, p_norm.ibm, ':', 'color', new_blue, 'linewidth', 3);

plot(t_baud/1e-12, nel0_baud, 'o', 'linewidth', 2, 'color', 'k', 'markerfacecolor', 'k', 'markersize', 8);
plot(t_baud/1e-12, nel2_baud, 'o', 'linewidth', 2, 'color', stanford_red, 'markerfacecolor', stanford_red, 'markersize', 8);
plot(t_baud/1e-12, ibm_baud, 'o', 'linewidth', 2, 'color', new_blue, 'markerfacecolor', new_blue, 'markersize', 8);

set(gca, 'fontsize', 18);
xlabel('Time (ps)', 'fontsize', 18);
ylabel('Normalized Pulse Response', 'fontsize', 18);
xlim([0, 800]);
ylim([-0.2, 1.2]);
box on;
legend('0.76 m FR4 ref', '1.09 m FR4 ref', '1.0 m Meg ref');
save_fig('./figures/channel_plots_pulse_resp.eps');

