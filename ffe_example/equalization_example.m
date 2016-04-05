clear all; close all; 
addpath('/home/rboesch/thesis/matlab/lib');
run('/home/rboesch/thesis/matlab/thesis.m');
%%
load('hs.mat');
x_p = [zeros(500, 1); ones(50, 1); zeros(500, 1)];
t_os = (0:length(x_p)-1)*1e-12-500e-12;
t_2xbaud = t_os(25:25:end);

p_os(:, 1) = convData(x_p, hs(:, 4));
p_amp = max(p_os(:, 1));
N = 5;
for k = 1:N-1
    p_os(:, k+1) = circshift(p_os(:, k), 25);
end
p_os = p_os/p_amp;
p_2xbaud = p_os(25:25:end, :);

%%
find_opt = false;
if find_opt
    coeffs_opt = brute_force_pmr_opt(p_2xbaud(1:2:end, :), 5,  0.2);
    save('coeffs_opt.mat', 'coeffs_opt');
else
    load('coeffs_opt.mat');
end
plot(t_os, p_os*coeffs_opt); hold all;
plot(t_2xbaud, p_2xbaud*coeffs_opt, 'o'); hold all;


%%
t_ui = (t_os-25e-12)/50e-12;
t_baud_ui = (t_2xbaud(1:2:end)-25e-12)/50e-12;
figure; hold all;
for k = 1:5
    p_summed = plot(t_ui, p_os(:, k)*coeffs_opt(k)/31, '-k', 'linewidth', 1);
%     plot(t_2xbaud(1:2:end), p_2xbaud(1:2:end, k)*coeffs_opt(k)/31, 'ok');
end
p_eq = plot(t_ui, p_os*coeffs_opt/31, '-k', 'linewidth', 3);
plot(t_baud_ui, p_2xbaud(1:2:end, :)*coeffs_opt/31, 'ok', 'linewidth', 2, 'markerfacecolor', 'k', 'markersize', 8);
xlim([0, 7]);
set(gca, 'xtick', 0:7)
xlabel('Time (UI)', 'fontsize', 18);
ylabel('Pulse Response', 'fontsize', 18);
set(gca, 'fontsize', 18);
ylim([-1.1, 1.1]);
box on;
legend([p_summed, p_eq], {'Summed Pulses', 'Equalized Pulse'});
save_fig('./figures/equalization_example_pulse_responses.eps');

%%
p_ch = plot(t_ui, p_opt_amp*p_os(:, 1), '--', 'color', stanford_red, 'linewidth', 3);
plot(t_baud_ui, p_opt_amp*p_2xbaud(1:2:end, 1), 'o', 'linewidth', 2, 'color', stanford_red, 'markerfacecolor', stanford_red, 'markersize', 8);
ylim([-0.1, 0.3]);
legend([p_summed, p_eq, p_ch], {'Summed Pulses', 'Equalized Pulse', 'Channel Pulse'});
save_fig('./figures/equalization_example_pulse_responses_zoomed.eps');

%%
h_eqs(:, 1) = hs(:, 4);
h_eqs(:, 2) = circshift(hs(:, 4), 25);
h_eqs(:, 3) = circshift(hs(:, 4), 50);
h_eqs(:, 4) = circshift(hs(:, 4), 75);
h_eqs(:, 5) = circshift(hs(:, 4), 100);
h_eq = h_eqs*coeffs_opt/31;
save('h_eq.mat', 't_h', 'h_eq');
figure; hold all;
plot(t_h, h_eqs, '-k');
plot(t_h, h_eq);

%%
load('x.mat');
x_lim = [900, 1700];
y_lim = [-1.1, 1.1];

y_eq = convData(x, h_eq);
y_eqa = prbs_align(x, y_eq);

y4 = convData(x, hs(:, 4));
y4a = prbs_align(x, y4);

figure; hold all;
plot(t/1e-12, x);
plot(t/1e-12, y4a);
plot(t/1e-12, y_eqa*5);
xlim(x_lim); ylim(y_lim);

%%
figure; hold all;
plot(t/1e-12, 4*y_eqa, '-k', 'linewidth', 3);
xlim(x_lim); ylim(y_lim); axis off;

plot(t(25:50:end)/1e-12, 4*y_eqa(25:50:end), 'ok', 'linewidth', 3);

plot(t/1e-12, 4*y_eqa, '-k', 'linewidth', 10);
xlim(x_lim); ylim(y_lim); axis off;

%% eye diagrams
figure; hold all;
plot_eye_diagram(y4a, 50);
axis off;

figure; hold all;
plot_eye_diagram(y_eqa, 50);
axis off;


%% frequency response
N = 1024;
h4_fft = fft(hs(:, 4), N)/(N/2);
h_eq_fft = fft(h_eq, N)/(N/2); 
h_eq_fft = h_eq_fft/h4_fft(1);
h4_fft = h4_fft/h4_fft(1);
ratio_fft = h_eq_fft./h4_fft;

f = (0:N-1)/N/1e-12;

figure; 
semilogx(f/1e9, db(h4_fft), '-k', 'linewidth', 3); hold all;
xlim([1, 30]);
ylim([-60, 20]);
xlabel('Frequency [GHz]');
ylabel('Magnitude [dB]');
semilogx(f/1e9, db(ratio_fft), '--k', 'linewidth', 3); hold all;
semilogx(f/1e9, db(h_eq_fft), '-', 'color', stanford_red, 'linewidth', 3); hold all;

figure; 
semilogx(f/1e9, db(h4_fft), '-k', 'linewidth', 3); hold all;
semilogx(f/1e9, db(10*h_eq_fft), '-', 'color', stanford_red, 'linewidth', 3); hold all;
xlim([1, 30]);
ylim([-60, 20]);
xlabel('Frequency [GHz]');
ylabel('Magnitude [dB]');

