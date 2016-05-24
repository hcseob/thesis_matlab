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

text(1, -0.28, 'p1', 'fontsize', 18);
text(1.15, 0.6, 'p2', 'fontsize', 18);
text(4.5, -0.5, 'p3', 'fontsize', 18);
text(3, 0.34, 'p4', 'fontsize', 18);
text(2, -0.08, 'p5', 'fontsize', 18);
text(1.75, 0.34, 'po', 'fontsize', 18);

save_fig('./figures/equalization_example_pulse_responses.eps');

%%
scale = 1/max(p_os*coeffs_opt/31);
figure; hold all;
p_eq = plot(t_ui, scale*p_os*coeffs_opt/31, '-k', 'linewidth', 3);
plot(t_baud_ui, scale*p_2xbaud(1:2:end, :)*coeffs_opt/31, 'ok', 'linewidth', 2, 'markerfacecolor', 'k', 'markersize', 8);

p_ch = plot(t_ui, p_os(:, 1), '--', 'color', stanford_red, 'linewidth', 3);
plot(t_baud_ui, p_2xbaud(1:2:end, 1), 'o', 'linewidth', 2, 'color', stanford_red, 'markerfacecolor', stanford_red, 'markersize', 8);

xlim([0, 7]);
set(gca, 'xtick', 0:7);
ylim([-0.2, 1.1]);
set(gca, 'ytick', [0, 1]);
xlabel('Time (UI)', 'fontsize', 18);
ylabel('Normalized Pulse Response', 'fontsize', 18);
set(gca, 'fontsize', 18);
box on;

legend([p_eq, p_ch], {'Equalized Pulse', 'Channel Pulse'});
save_fig('./figures/equalization_example_pulse_responses_zoomed.eps');

%%
h_eqs(:, 1) = hs(:, 4);
h_eqs(:, 2) = circshift(hs(:, 4), 25);
h_eqs(:, 3) = circshift(hs(:, 4), 50);
h_eqs(:, 4) = circshift(hs(:, 4), 75);
h_eqs(:, 5) = circshift(hs(:, 4), 100);
h_eq = h_eqs*coeffs_opt/31;
save('h_eq.mat', 't_h', 'h_eq');

%%
load('x.mat');
x_lim = [900, 1700];
y_lim = [-1.1, 1.1];

y_eq = convData(x, h_eq);
y_eqa = prbs_align(x, y_eq);

y4 = convData(x, hs(:, 4));
y4a = prbs_align(x, y4);

%%
os = 26;
eq_norm = y_eqa*4.4-0.5;
y0 = (x - min(x))/2;
y1 = (y4a - min(y4a))/2;
y2 = (eq_norm - min(eq_norm) - 0.1)/2;
y1 = y1/max(y2(1:300));
y2 = y2/max(y2(1:300));

UIs = (t-900e-12)/50e-12;

figure; hold all;
p0 = plot(UIs, y0, ':', 'color', new_blue, 'linewidth', 3);
p1 = plot(UIs, y1, '--', 'color', stanford_red, 'linewidth', 3);
plot(UIs(os:50:end), y1(1+os:50:end), 'o', 'color', stanford_red, 'linewidth', 2, 'markerfacecolor', stanford_red, 'markersize', 8);
plot([UIs(1), UIs(end)], max(y1)*ones(2, 1), '--', 'color', stanford_red, 'linewidth', 1);


p2 = plot(UIs, y2, 'color', 'k', 'linewidth', 3);
plot(UIs(os:50:end), y2(1+os:50:end), 'o', 'color', 'k', 'linewidth', 2, 'markerfacecolor', 'k', 'markersize', 8);
plot([UIs(1), UIs(end)], max(y2)*ones(2, 1), '--', 'color', 'k', 'linewidth', 1);
xlim([0, 15])
ylim([-0.2, 2.5]);
box on;
set(gca, 'ytick', [0, 1, 2, 3]);
set(gca, 'fontsize', 18);
xlabel('Time (UI)', 'fontsize', 18);
ylabel('Normalized Amplitude', 'fontsize', 18);
legend([p0, p1, p2], {'Transmit Signal', 'Receive Signal', 'Equalized Signal'}, 'location', 'northwest');
save_fig('./figures/equalization_example_pmr_comp.eps');

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
%%
figure;
semilogx(f/20e9, db(10*h_eq_fft), '-', 'color', 'k', 'linewidth', 3); hold all;

semilogx(f/20e9, db(h4_fft), '--', 'color', stanford_red, 'linewidth', 3); hold all;
semilogx(f/20e9, db(10*ratio_fft), ':', 'color', new_blue, 'linewidth', 3); hold all;

xlim([0.1, 2]);
ylim([-40, 40]);
set(gca, 'fontsize', 18);
legend('Channel+FFE', 'Channel', 'FFE', 'location', 'northwest');
xlabel('Frequency (fbaud)', 'fontsize', 18);
ylabel('Normalized Magnitude (dB)', 'fontsize', 18);
save_fig('./figures/equalization_example_freq_domain.eps');

%%
figure; 
semilogx(f/1e9, db(h4_fft), '-k', 'linewidth', 3); hold all;
semilogx(f/1e9, db(10*h_eq_fft), '-', 'color', stanford_red, 'linewidth', 3); hold all;
xlim([1, 30]);
ylim([-60, 20]);
xlabel('Frequency [GHz]');
ylabel('Magnitude [dB]');


