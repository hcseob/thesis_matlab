clear all; close all; addpath('../../../thesis/matlab/lib');
addpath('../lib/old_lib');
stanford_red = [140, 21, 21]/255;

load('../../data/bench/board2/prbs20gC10_eq.mat');
[prbs_eq0, prbss_eq0, ~, ~] = clock_recovery(prbs.vod);
t = (1:length(prbs_eq0))'*12.5e-12;

load('../../data/bench/board2/prbs20g_ch.mat');
[prbs_ch, prbss_ch, ~, ~] = clock_recovery(prbs.vod);
prbs_ch = prbs_align(prbs_eq0, prbs_ch);
t = prbs.t(1:length(prbs_ch));

%%
% plot_eye_diagram(prbs_eq0, 4);
figure; hold all;
plot(t, prbs_eq0, '-k');
plot(t(1:4:end), prbs_eq0(1:4:end), 'o')

%%
samp = prbs_eq0(1:4:end);
bits = (samp > 0)*2 -1;

D = 2; % 2 tap DFE
bits_cp = [bits(end-D+1:end); bits];
B = [];
for k = 1:length(samp)
    B = [B;bits_cp(k:D+k-1)'];
end

dfe = B*(B\samp);
dfe4x = repmat(dfe, 1, 4)';
dfe4x = dfe4x(:);

%%
figure;
plot_eye_diagram(samp - dfe, 1);

figure;
plot_eye_diagram(samp, 1);


%%
figure; 
plot_eye_diagram(prbs_eq0, 4);
ylim([-25e-3, 25e-3]);
% print('-depsc', './figures/eye_eq0');
eq_dfe = prbs_eq0-circshift(dfe4x, -2);
L = length(eq_dfe);
osr = 10;
t_os = (0:8*osr)/osr*12.5e-12;
eq_dfe_os = interp1(1:L, eq_dfe, 1:1/osr:L, 'spline');

figure; 
plot_eye_diagram(eq_dfe_os, 4*osr);
ylim([-25e-3, 25e-3]);
% print('-depsc', './figures/eye_eq0_after_dfe');

%%
figure;
[~, ~, ~, vout, vtop, vbot] = plotEyeDiagram(eq_dfe_os, 4*osr);

%%
vn = 9e-9*sqrt(8e9);
vsig = (vtop - vbot)/2;
ber = erfc(vsig/vn/sqrt(2))/2;
figure;
semilogy(t_os/1e-12-53, ber, '-ko', 'linewidth', 2); hold all;
plot([-100, 100], 1e-12*[1, 1], '--k')
xlim([-20, 20]);
grid on;
set(gca, 'fontsize', 14);
xlabel('Sampling Phase [ps]', 'fontsize', 18);
ylabel('Bit Error Rate', 'fontsize', 18);
% print('-depsc', './figures/bathtub_pam2');

%%
load('../../../thesis/data/bench/board2/noise_sweep_bl.mat');
hinfo = hdf5info('~/thesis/data/bench/direct_from_scope/20150812/B1Noise1FFE_AllMax.h5');
vn_max = hdf5read(hinfo.GroupHierarchy.Groups(3).Groups(1).Datasets(1));
hinfo = hdf5info('~/thesis/data/bench/direct_from_scope/20150812/B1Noise1FFE_AllZeros.h5');
vn_min = hdf5read(hinfo.GroupHierarchy.Groups(3).Groups(1).Datasets(1));

[std(vn_max), std(vn_min)]

%%
load('../../../thesis/data/bench/board2/noise_sweep_bl.mat');
load('../../../thesis/data/bench/board2/noise_sweep.mat');
data = csvread('../../../thesis/data/simulation/simulated_noise.csv', 1, 0);
coeffs_sim = data(:, 1);
vn_sim_10G = data(:, 2);
vn_sim_8G = data(:, 4);
vn_sim_6G = data(:, 6);

BW = 8e9;
BW_scope = 33e9;
figure; hold all;

plot(coeffs_sim, vn_sim_10G/1e-3, '-k', 'linewidth', 3);
% plot(coeffs_sim, vn_sim_8G/1e-3, '-k', 'linewidth', 2);
% plot(coeffs_sim, vn_sim_6G/1e-3, '--k', 'linewidth', 2);
plot(0:31, sqrt(20e9)*sqrt(vn.^2-vn_bl.^2)/1e-3, '-', 'linewidth', 3, 'color', stanford_red);
xlabel('Coeffs Value', 'fontsize', 18);
ylabel('Noise (mVRMS)', 'fontsize', 18);
set(gca, 'fontsize', 18);
xlim([1, 31]);
ylim([0, 1.0]);
% grid on;
box on;
legend('Simulation', 'Measurement', 'location', 'northwest');
save_fig('./figures/vn_rms.eps');
%%
ylim([0, 1.2]);
plot(0:31, sqrt(20e9)*vn/1e-3, '-r', 'linewidth', 2);
plot(0:31, sqrt(20e9)*vn_bl/1e-3, '-b', 'linewidth', 2);
save_fig('./figures/vn_rms_withbaseline.eps');

%%
BW = 5e9;
figure; hold all;
plot(coeffs_sim, vn_sim_10G/sqrt(BW)/1e-9, '-k', 'linewidth', 2);
plot(0:31, sqrt(20e9)/sqrt(BW)*sqrt(vn.^2-vn_bl.^2)/1e-9, '-', 'linewidth', 2, 'color', stanford_red);
xlabel('Coeffs Value', 'fontsize', 18);
ylabel('Spot Noise [nV/sqrt(Hz)]', 'fontsize', 18);
set(gca, 'fontsize', 14);
xlim([1, 31]);
ylim([0, 15]);
% ylim([0, 1.0]);
grid on;
save_fig('./figures/vn_spot.eps');
