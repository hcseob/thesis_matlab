clear all; close all; run('~/thesis/matlab/thesis.m'); addpath('./lib');

tau = 25e-12;
cen = round(log10(1/tau/2/pi));
f = logspace(cen-2, cen+2, 1000);
w = 2*pi*f;
w_gd = (w(1:end-1)+w(2:end))/2;

%% bessel delays
bs1 = bessel_sys(1, tau);
bs2 = bessel_sys(2, tau);
bs3 = bessel_sys(3, tau);



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
semilogx(w_gd/2/pi/1e9, gd1/1e-12, '-k', 'linewidth', 2); hold all;
semilogx(w_gd/2/pi/1e9, gd2/1e-12, '--', 'linewidth', 2, 'color', stanford_red);
semilogx(w_gd/2/pi/1e9, gd3/1e-12, '-.', 'linewidth', 2, 'color', new_blue);
set(gca, 'fontsize', 14);
legend('First Order Bessel', 'Second Order Bessel', 'Third Order Bessel');
xlabel('Frequency [GHz]', 'fontsize', 14);
ylabel('Group Delay [ps]', 'fontsize', 14)
print('-depsc', './figures/group_delay_bessel');

figure; 
subplot(211);
semilogx(f/1e9, db(squeeze(g1)), '-k', 'linewidth', 2); hold all;
semilogx(f/1e9, db(squeeze(g2)), '--', 'linewidth', 2, 'color', stanford_red); hold all;
semilogx(f/1e9, db(squeeze(g3)), '-.', 'linewidth', 2, 'color', new_blue); hold all;
ylim([-100, 10])
set(gca, 'fontsize', 14);
legend('First Order Bessel', 'Second Order Bessel', 'Third Order Bessel', 'location', 'southwest');
xlabel('Frequency [GHz]', 'fontsize', 14);
ylabel('Magnitude [dB]', 'fontsize', 14)
subplot(212);
semilogx(f/1e9, p1*180/pi, '-k', 'linewidth', 2); hold all;
semilogx(f/1e9, p2*180/pi, '--', 'linewidth', 2, 'color', stanford_red); hold all;
semilogx(f/1e9, p3*180/pi, '-.', 'linewidth', 2, 'color', new_blue); hold all;
set(gca, 'fontsize', 14);
xlabel('Frequency [GHz]', 'fontsize', 14);
ylabel('Phase [deg]', 'fontsize', 14)
print('-depsc', './figures/mag_phase_bessel');

%% pade delays
bs1 = pade_sys(1, tau);
bs2 = pade_sys(2, tau);
bs3 = pade_sys(3, tau);



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
semilogx(w_gd/2/pi/1e9, gd1/1e-12, '-k', 'linewidth', 2); hold all;
semilogx(w_gd/2/pi/1e9, gd2/1e-12, '--', 'linewidth', 2, 'color', stanford_red);
semilogx(w_gd/2/pi/1e9, gd3/1e-12, '-.', 'linewidth', 2, 'color', new_blue);
set(gca, 'fontsize', 14);
legend('First Order Pade', 'Second Order Pade', 'Third Order Pade');
xlabel('Frequency [GHz]', 'fontsize', 14);
ylabel('Group Delay [ps]', 'fontsize', 14)
print('-depsc', './figures/group_delay_pade');

figure; 
subplot(211);
semilogx(f/1e9, db(squeeze(g1)), '-k', 'linewidth', 2); hold all;
semilogx(f/1e9, db(squeeze(g2)), '--', 'linewidth', 2, 'color', stanford_red); hold all;
semilogx(f/1e9, db(squeeze(g3)), '-.', 'linewidth', 2, 'color', new_blue); hold all;
ylim([-100, 10])
set(gca, 'fontsize', 14);
legend('First Order Pade', 'Second Order Pade', 'Third Order Pade', 'location', 'southwest');
xlabel('Frequency [GHz]', 'fontsize', 14);
ylabel('Magnitude [dB]', 'fontsize', 14)
subplot(212);
semilogx(f/1e9, p1*180/pi, '-k', 'linewidth', 2); hold all;
semilogx(f/1e9, p2*180/pi, '--', 'linewidth', 2, 'color', stanford_red); hold all;
semilogx(f/1e9, p3*180/pi, '-.', 'linewidth', 2, 'color', new_blue); hold all;
set(gca, 'fontsize', 14);
xlabel('Frequency [GHz]', 'fontsize', 14);
ylabel('Phase [deg]', 'fontsize', 14)
print('-depsc', './figures/mag_phase_pade');
