clear all; close all; addpath('../../matlab_old/lib');
stanford_red = [140, 21, 21]/255;
%% load data
% load bench data
% load channel and equalized data
load('../../data/bench/board2/prbs20g_ch.mat');
[prbs_ch, vods_ch, ~, ~] = clock_recovery(prbs.vod);
load('../../data/bench/board2/prbs20gC0_eq.mat');
[prbs_eq0, vods_eq0, ~, ~] = clock_recovery(prbs.vod);
load('../../data/bench/board2/prbs20gC10_eq.mat');
[prbs_eq10, vods_eq10, ~, ~] = clock_recovery(prbs.vod);
t_ch = (0:length(prbs_ch)-1)*12.5e-12;

% load prbs data
hinfo = hdf5info('../../data/bench/direct_from_scope/20150809/B1PRBS20G.h5');
data = hdf5read(hinfo.GroupHierarchy.Groups(3).Groups(1).Datasets(1));
[prbs_bench, prbss_bench, ~, ~] = clock_recovery(data);

% load sim data
load('../../data/simulation/prbs_power_sweep.mat');
t_start = t(end) - t_ch(end);
prbs_ch_sim = interp1(t, vid(:, 5), t_start+t_ch)';
prbs_eq_sim = interp1(t, vod(:, 5), t_start+t_ch)';

%% preprocess data
% aligned signals to prbs_ch
prbs_bench = prbs_align(prbs_ch, prbs_bench);
prbs_eq0 = prbs_align(prbs_ch, prbs_eq0);
prbs_eq10 = prbs_align(prbs_ch, prbs_eq10);
prbs_ch_sim = prbs_align(prbs_ch, prbs_ch_sim);
prbs_eq_sim = prbs_align(prbs_ch, prbs_eq_sim);

% oversample
N = length(prbs_ch);
OS = 10;
y_prbs = interp1(prbs_bench, (1:1/OS:N), 'spline');
y_eq10 = interp1(prbs_eq10, (1:1/OS:N), 'spline');
y_chsim = interp1(prbs_ch_sim, (1:1/OS:N), 'spline');
y_eqsim = interp1(prbs_eq_sim, (1:1/OS:N), 'spline');
y_ch = interp1(prbs_ch, (1:1/OS:N), 'spline');
t_os = interp1(t_ch, (1:1/OS:N));

%% bench equalized sid
step_size = 1e-3;
edge_shifts = [4, 0, -4, 4]*1e-12 - 80e-12;
[h_eq10, s_eq10, d_eq10, x_eq10] = lms_hsd(t_os, y_eq10, 50e-12, edge_shifts, 4000, step_size, 100);
sdr_eq_bench = 10*log10(var(s_eq10)/var(d_eq10));

%% bench channel sid
edge_shifts = [0, 6, 0, -5]*1e-12 - 80e-12;
[h_ch, s_ch, d_ch, x_ch] = lms_hsd(t_os, y_ch, 50e-12, edge_shifts, 4000, 1e-3, 100);
sdr_ch_bench = 10*log10(var(s_ch)/var(d_ch))
[h_ch_ns, s_ch_ns, d_ch_ns, x_ch_ns] = lms_hsd(t_os, y_ch, 50e-12, ones(4, 1)*(-80e-12), 4000, step_size, 100);
sdr_ch_ns_bench = 10*log10(var(s_ch_ns)/var(d_ch_ns))
[h_ch_short, s_ch_short, d_ch_short, x_ch_short] = lms_hsd(t_os, y_ch, 50e-12, edge_shifts, 2000, step_size, 100);
sdr_ch_short_bench = 10*log10(var(s_ch_short)/var(d_ch_short))

%% bench prbs sid
edge_shifts = [4, 11, 0, -6]*1e-12 - 80e-12;
[h_prbs, s_prbs, d_prbs, x_prbs] = lms_hsd(t_os, y_prbs, 50e-12, edge_shifts, 4000, step_size, 100);
sdr_prbs_bench = 10*log10(var(s_prbs)/var(d_prbs))

%% simulated equalized sid
edge_shifts = [0, 1, 1, -1]*1e-12 - 80e-12;
[h_eqsim, s_eqsim, d_eqsim, x_eqsim] = lms_hsd(t_os, y_eqsim, 50e-12, edge_shifts, 4000, step_size, 100);
sdr_eq_sim = 10*log10(var(s_eqsim)/var(d_eqsim))

%% simulated channel sid
edge_shifts = [0, 1, 1, -1]*1e-12 - 80e-12;
[h_chsim, s_chsim, d_chsim, x_chsim] = lms_hsd(t_os, y_chsim, 50e-12, edge_shifts, 4000, step_size, 100);
sdr_ch_sim = 10*log10(var(s_chsim)/var(d_chsim))

%% Impulse responses
L = length(h_eqsim);
t_imp = t_os(1:L);

%% equalized
os = 31; os_sim = 26;
figure; hold all;
p1 = plot(t_imp/1e-12, h_eq10, '-k', 'linewidth', 2);
plot(t_imp(os:40:end)/1e-12, h_eq10(os:40:end), 'ok', 'linewidth', 2);
ratio = max(h_eq10)/max(h_eqsim);
p2 = plot(t_imp/1e-12, h_eqsim*ratio, '-', 'linewidth', 2, 'color', stanford_red);
plot(t_imp(os_sim:40:end)/1e-12, h_eqsim(os_sim:40:end)*ratio, 'o', 'linewidth', 2, 'color', stanford_red);
xlabel('Time [ps]', 'fontsize', 18);
ylabel('Impulse Response', 'fontsize', 18);
xlim([0, t_imp(end)/10/1e-12]);
legend([p1, p2], {'Bench', 'Simulated'});
set(gca, 'fontsize', 14);
save_fig('./figures/impresp_eq.eps');

%% channel
os = 21; os_sim = 24;
figure; hold all;
p1 = plot(t_imp/1e-12, h_ch, '-k', 'linewidth', 2);
plot(t_imp(os:40:end)/1e-12, h_ch(os:40:end), 'ok', 'linewidth', 2);
ratio = max(h_ch)/max(h_chsim);
p2 = plot(t_imp/1e-12, h_chsim*ratio, '-', 'linewidth', 2, 'color', stanford_red);
plot(t_imp(os_sim:40:end)/1e-12, h_chsim(os_sim:40:end)*ratio, 'o', 'linewidth', 2, 'color', stanford_red);
xlabel('Time [ps]', 'fontsize', 18);
ylabel('Impulse Response', 'fontsize', 18);
xlim([0, t_imp(end)/10/1e-12]);
legend([p1, p2], {'Bench', 'Simulated'});
set(gca, 'fontsize', 18);
save_fig('./figures/impresp_ch.eps');

%% prbs
% figure; hold all;
% p1 = plot(t_imp/1e-12, h_prbs, '-k');
% ratio = max(h_ch)/max(h_chsim);
% xlabel('Time [ps]');
% ylabel('Impulse Response');
% xlim([0, t_imp(end)/10/1e-12]);
% legend('Bench');
% % print('-dpng', './figures/impresp_prbs');
% xlim([0, t_imp(end)/1e-12]);
% % print('-dpng', './figures/impresp_prbs_full');

%% frequency responses
N = length(h_eq10);
dt = 12.5e-12/10;
f = (0:N-1)/N/dt;

% bench
h_eq10_fft = fft(h_eq10);
h_ch_fft = fft(h_ch);
figure;
semilogx(f/1e9, db(h_eq10_fft/h_eq10_fft(2)), '-k', 'linewidth', 2); hold all;
semilogx(f/1e9, db(h_ch_fft/h_ch_fft(2)), '-', 'linewidth', 2, 'color', stanford_red);
xlim([0, 30]);
ylim([-40, 10]);
grid on;
xlabel('Frequency [GHz]', 'fontsize', 18);
ylabel('Magnitude [dB]', 'fontsize', 18);
set(gca, 'fontsize', 14');
legend('Equalized', 'Channel');
save_fig('./figures/freqresp_ben.eps');

% simulated
h_eqsim_fft = fft(h_eqsim);
h_chsim_fft = fft(h_chsim);
figure;
semilogx(f/1e9, db(h_eqsim_fft/h_eqsim_fft(2)), '-k', 'linewidth', 2); hold all;
semilogx(f/1e9, db(h_chsim_fft/h_chsim_fft(2)), '-', 'linewidth', 2, 'color', stanford_red);
xlim([0, 30]);
ylim([-40, 10]);
grid on;
xlabel('Frequency [GHz]', 'fontsize', 18);
ylabel('Magnitude [dB]', 'fontsize', 18);
set(gca, 'fontsize', 14');
legend('Equalized', 'Channel');
save_fig('./figures/freqresp_sim.eps');
