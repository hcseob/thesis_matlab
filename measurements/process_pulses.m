clear all; close all; addpath('/home/rboesch/thesis/matlab/lib');
load('/home/rboesch/thesis/data/bench/board2/allpulses20gC10_eq.mat');
run('~/thesis/matlab/thesis.m');
%%
os = 3;
figure; hold all;
plot(pulse.t/1e-12, pulse.vod, '-k', 'linewidth', 2);
plot(pulse.t(os:4:end)/1e-12, pulse.vod(os:4:end), 'ok', 'linewidth', 2);

%%
os = 4;
p_eq_calc = sum(pulses.vod, 2);
p_eq = prbs_align(p_eq_calc, pulse.vod);
p_eq = p_eq - p_eq(1);

%%
load('/home/rboesch/thesis/data/bench/board2/pulse20g_ch.mat');
p_ch = pulse.vod;
p_ch = prbs_align(p_eq, p_ch);
p_ch = p_ch - p_ch(1);

figure; hold all;
plot(pulses.t(:, 1)/1e-12, pulses.vod, '-k', 'linewidth', 2);
plot(pulses.t(:, 1)/1e-12, p_eq, '-', 'linewidth', 2, 'color', stanford_red);
plot(pulses.t(os:4:end, 1)/1e-12, p_eq(os:4:end), 'ok', 'linewidth', 2, 'color', stanford_red);
xlabel('Time (ps)', 'fontsize', 18);
ylabel('Voltage (V)', 'fontsize', 18);
set(gca, 'fontsize', 18);
xlim([100, 500]); ylim([-30e-3, 50e-3]);
save_fig('./figures/family_meas.eps');

%%
figure; hold all;
plot(pulses.t(:, 1)/1e-12, p_eq, '-', 'linewidth', 2, 'color', stanford_red);
plot(pulses.t(os:4:end, 1)/1e-12, p_eq(os:4:end), 'ok', 'linewidth', 2, 'color', stanford_red);
xlabel('Time (ps)', 'fontsize', 18);
ylabel('Voltage (V)', 'fontsize', 18);
set(gca, 'fontsize', 18);
xlim([100, 500]); ylim([-30e-3, 50e-3]);
save_fig('./figures/family_meas_just_eq.eps');
plot(pulses.t(:, 1)/1e-12, p_ch, '-k', 'linewidth', 2);
plot(pulses.t(os:4:end, 1)/1e-12, p_ch(os:4:end), 'ok', 'linewidth', 2);
xlim([100, 500]); ylim([-50e-3, 200e-3]);
save_fig('./figures/family_meas_eqandch.eps');


%%
figure; hold all;
plot(pulses.t(:, 1)/1e-12, p_eq/max(p_eq), '-', 'linewidth', 2, 'color', stanford_red);
plot(pulses.t(os:4:end, 1)/1e-12, p_eq(os:4:end)/max(p_eq), 'ok', 'linewidth', 2, 'color', stanford_red);
plot(pulses.t(:, 1)/1e-12, p_ch/max(p_ch), '-k', 'linewidth', 2);
plot(pulses.t(os:4:end, 1)/1e-12, p_ch(os:4:end)/max(p_ch), 'ok', 'linewidth', 2);
xlabel('Time (ps)', 'fontsize', 18);
ylabel('Normalized Voltage', 'fontsize', 18);
set(gca, 'fontsize', 18);
xlim([100, 500]); ylim([-0.3, 1.1]);

save_fig('./figures/ch_eq_comp.eps');

%%
load('/home/rboesch/thesis/data/bench/board2/prbs20gC10_eq.mat');
[prbs_eq0, prbss_eq0, ~, ~] = clock_recovery(prbs.vod);
t = (1:length(prbs_eq0))'*12.5e-12;

load('/home/rboesch/thesis/data/bench/board2/prbs20g_ch.mat');
[prbs_ch, prbss_ch, ~, ~] = clock_recovery(prbs.vod);
prbs_ch = prbs_align(prbs_eq0, prbs_ch);


%%
scale = 5.1;
delta = min(prbs_ch)-min(prbs_eq0*scale)-0.03;
prbs_eq = (prbs_eq0*scale+delta);

% no scaled
figure; hold all;
plot(t/1e-12, prbs_ch, '-k', 'linewidth', 2);
plot(t/1e-12, prbs_eq0, '-', 'linewidth', 2, 'color', stanford_red); hold all;
ylim([-0.2, 0.2]);
set(gca, 'fontsize', 18);
xlabel('Time (ps)', 'fontsize', 18); 
ylabel('Voltage (V)', 'fontsize', 18);
save_fig('./figures/dr_improvement_alldata_noscale.eps');
xlim([0, 2000]);
save_fig('./figures/dr_improvement_alldata_noscale_zoomed.eps');

% scaled
figure; hold all;
plot(t/1e-12, prbs_ch, '-k', 'linewidth', 2);
plot(t/1e-12, prbs_eq0*scale, '-', 'linewidth', 2, 'color', stanford_red); hold all;
ylim([-0.2, 0.2]);
set(gca, 'fontsize', 18);
xlabel('Time (ps)', 'fontsize', 18); 
ylabel('Voltage (V)', 'fontsize', 18);
save_fig('./figures/dr_improvement_alldata.eps');
xlim([0, 2000]);
save_fig('./figures/dr_improvement_alldata_zoomed.eps');

% scaled and offset
figure; hold all;
plot(t/1e-12, prbs_ch, '-k', 'linewidth', 2);
plot(t/1e-12, prbs_eq, '-', 'linewidth', 2, 'color', stanford_red); hold all;
ylim([-0.2, 0.2]);
set(gca, 'fontsize', 18);
xlabel('Time (ps)', 'fontsize', 18); 
ylabel('Voltage (V)', 'fontsize', 18);
save_fig('./figures/dr_improvement_alldata_offset.eps');
xlim([0, 2000]);
save_fig('./figures/dr_improvement_offset_alldata_zoomed.eps');

%%
vpp_ch = max(prbs_ch) - min(prbs_ch);
vpp_eq = max(prbs_eq) - min(prbs_eq);
vpp_ch/vpp_eq
db(vpp_ch/vpp_eq)