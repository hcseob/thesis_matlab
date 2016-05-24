function gain_phase_group_delay_pade_alpha
run('~/thesis/matlab/thesis.m'); addpath('./lib');

tau = 25e-12;
cen = round(log10(1/tau/2/pi));
f = logspace(cen-2, cen+1, 100);
w = 2*pi*f;
w_gd = (w(1:end-1)+w(2:end))/2;

gid = ones(size(f));
pid = -w*tau;
gdid = ones(length(f)-1, 1)*tau;


%% pade delays
bs1 = pade_sys(1, tau, 0);
bs2 = pade_sys(1, tau, 1/3);
bs3 = pade_sys(1, tau, 1);

[g1, p1] = bode(bs1, w);
p1 = squeeze(p1)*pi/180;
gd1 = -diff(p1)./diff(w');

[g2, p2] = bode(bs2, w);
p2 = squeeze(p2)*pi/180;
gd2 = -diff(p2)./diff(w');

[g3, p3] = bode(bs3, w);
p3 = squeeze(p3)*pi/180;
gd3 = -diff(p3)./diff(w');

figure; 
semilogx(w_gd/2/pi/1e9, gd1/1e-12, '-', 'linewidth', 3, 'color', 'k'); hold all;
semilogx(w_gd/2/pi/1e9, gd2/1e-12, '--', 'linewidth', 3, 'color', stanford_red); hold all;
semilogx(w_gd/2/pi/1e9, gd3/1e-12, ':', 'linewidth', 3, 'color', new_blue); hold all;
% semilogx(w_gd/2/pi/1e9, gdid/1e-12, '--k'); hold all;
ylim([0, 50]);
set(gca, 'fontsize', font_size);
legend('a = 0', 'a = 1/3', 'a = 1', 'location', 'northeast');
xlabel('Frequency (GHz)', 'fontsize', font_size_label);
ylabel('Group Delay (ps)', 'fontsize', font_size_label);
save_fig('./figures/group_delay_pade_alpha.eps');

figure; 
subplot(211);
semilogx(f/1e9, db(squeeze(g1)), '-', 'linewidth', 3, 'color', 'k'); hold all;
semilogx(f/1e9, db(squeeze(g2)), '--', 'linewidth', 3, 'color', stanford_red); hold all;
semilogx(f/1e9, db(squeeze(g3)), ':', 'linewidth', 3, 'color', new_blue); hold all;
% semilogx(f/1e9, db(squeeze(gid)), '--k'); hold all;
% xlim([1, 100]);
ylim([-20, 10]);
set(gca, 'fontsize', font_size);
% legend('First Order Pade', 'Second Order Pade', 'Third Order Pade', 'location', 'southwest');
xlabel('Frequency (GHz)', 'fontsize', font_size_label);
ylabel('Magnitude (dB)', 'fontsize', font_size_label)
subplot(212);
semilogx(f/1e9, p1*180/pi, '-', 'linewidth', 3, 'color', 'k'); hold all;
semilogx(f/1e9, p2*180/pi-360, '--', 'linewidth', 3, 'color', stanford_red); hold all;
semilogx(f/1e9, p3*180/pi-360, ':', 'linewidth', 3, 'color', new_blue); hold all;
% semilogx(f/1e9, pid*180/pi, '--k'); hold all;
% xlim([1, 100]);
ylim([-200, 100]);
legend('a = 0', 'a = 1/3', 'a = 1', 'location', 'southwest');
set(gca, 'fontsize', font_size);
xlabel('Frequency (GHz)', 'fontsize', font_size_label);
ylabel('Phase (Degrees)', 'fontsize', font_size_label)
save_fig('./figures/gain_phase_pade_alpha.eps');


end
