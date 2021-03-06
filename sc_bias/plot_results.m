clear all; close all;
run('~/thesis/matlab/thesis.m');

vom = csvread('./vom_swept');

voncm_phase1 = csvread('./voncm_phase1');
vo_phase2 = csvread('./vo_phase2');
vo_phase2_2 = csvread('./vo_phase2_2');

vop_phase2 = csvread('./vop_phase2');
vop_phase2_2 = csvread('./vop_phase2_2');


figure; hold all;
subplot(211);
plot(vom, vop_phase2_2, '-k');
xlim([0.5, 1]);
ylim([0, 0.6]);
set(gca, 'ytick', [0:0.3:0.6]);
box on;
set(gca, 'fontsize', 18);
xlabel('Vbn (V)', 'fontsize', 18);
ylabel('Vbp (V)', 'fontsize', 18);

subplot(212);
plot(vom, vop_phase2, '-k');
xlim([0.5, 1]);
ylim([0, 0.6]);
set(gca, 'ytick', [0:0.3:0.6]);
box on;
set(gca, 'fontsize', 18);
xlabel('Vbn (V)', 'fontsize', 18);
ylabel('Vbp (V)', 'fontsize', 18);
save_fig('./figures/plot_results_sc_bias_nat_vs_unnat.eps');

%%
data = importdata('MonteCarlo.0.csv', ',', 1);

vop_scatter = data.data(:, 2);
vom_scatter = data.data(:, 3);

vom_ideal = 561.7e-3;
vop_ideal = 410.1e-3;

load('optlines.mat');
vomcm = vom_vcmopt;
vopcm = vop_vcmopt;
N = 30;
vopcm_fit = spline(vomcm(1:N:end), vopcm(1:N:end), vomcm);

vomg = vom_gainopt(12:end);
vopg = vop_gainopt(12:end);
vomg_fit = vomg(diff(vopg) > 5e-3);
vopg_fit = vopg(diff(vopg) > 5e-3);
vomg_fit = [vomg_fit(1:10), vomg_fit(12:end)];
vopg_fit = [vopg_fit(1:10), vopg_fit(12:end)];

figure; hold all;
plot(vomg_fit, vopg_fit, '--',  'color', stanford_red, 'linewidth', 3);
plot(vomcm, vopcm_fit, ':', 'color', new_blue, 'linewidth', 3);
plot(vom_scatter+0.05, vop_scatter-0.03, '.k');
% plot(vom_ideal+0.054, vop_ideal-0.016, 'o', 'color', stanford_red, 'linewidth', 2, 'markerfacecolor', stanford_red, 'markersize', 6);

set(gca, 'fontsize', 18);
xlabel('Vbn (V)', 'fontsize', 18);
ylabel('Vbp (V)', 'fontsize', 18);
xlim([0.5, 0.9]);
ylim([0, 0.6]);
set(gca, 'ytick', [0:0.2:0.6]);
box on;
legend('Constant Gain', 'Constant CM', 'Monte Carlo', 'location', 'southeast');
save_fig('./figures/plot_results_mc_gain_cm.eps');


