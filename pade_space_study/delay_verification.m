clear all; close all; run('~/thesis/matlab/thesis.m'); addpath('./lib');

% delay sys
pd1 = pade_sys(1, 25e-12);
pd2 = pade_sys(2, 25e-12);
pd3 = pade_sys(3, 25e-12);
bs1 = bessel_sys(1, 25e-12);
bs2 = bessel_sys(2, 25e-12);
bs3 = bessel_sys(3, 25e-12);
BW = 10e9;
rc = tf([1], [1/2/pi/BW, 1]);

% make pulse
t = 0:1e-12:500e-12;
p = zeros(size(t));
p(100e-12 < t & t < 150e-12) = 1;

% delay pulse
p_bs1 = lsim(bs1, p, t);
p_bs2 = lsim(bs2, p, t);
p_bs3 = lsim(bs3, p, t);

p_pd1 = lsim(pd1, p, t);
p_pd2 = lsim(pd2, p, t);
p_pd3 = lsim(pd3, p, t);

figure; hold all;
plot(t, p, '-k');
plot(t, p_bs1, '-b');
plot(t, p_bs2, '-r');
plot(t, p_bs3, '-g');

figure; hold all;
plot(t, p, '-k');
plot(t, p_pd1, '-b');
plot(t, p_pd2, '-r');
plot(t, p_pd3, '-g');


%%
[mag, phase, w] = bode(bs1);
phase = squeeze(phase)*pi/180;
w_bs1 = (w(1:end-1)+w(2:end))/2;
tau_bs1 = -diff(squeeze(phase))./diff(w);

[mag, phase, w] = bode(bs2);
phase = squeeze(phase)*pi/180;
w_bs2 = (w(1:end-1)+w(2:end))/2;
tau_bs2 = -diff(squeeze(phase))./diff(w);

[mag, phase, w] = bode(bs3);
phase = squeeze(phase)*pi/180;
w_bs3 = (w(1:end-1)+w(2:end))/2;
tau_bs3 = -diff(squeeze(phase))./diff(w);

[mag, phase, w] = bode(pd1);
phase = squeeze(phase)*pi/180;
w_pd1 = (w(1:end-1)+w(2:end))/2;
tau_pd1 = -diff(squeeze(phase))./diff(w);

[mag, phase, w] = bode(pd2);
phase = squeeze(phase)*pi/180;
w_pd2 = (w(1:end-1)+w(2:end))/2;
tau_pd2 = -diff(squeeze(phase))./diff(w);

[mag, phase, w] = bode(pd3);
phase = squeeze(phase)*pi/180;
w_pd3 = (w(1:end-1)+w(2:end))/2;
tau_pd3 = -diff(squeeze(phase))./diff(w);

figure; 
semilogx(w_bs1/2/pi/1e9, tau_bs1/1e-12, '-k'); hold all;
semilogx(w_bs2/2/pi/1e9, tau_bs2/1e-12, '-b');
semilogx(w_bs3/2/pi/1e9, tau_bs3/1e-12, '-r');
semilogx(w_pd1/2/pi/1e9, tau_pd1/1e-12, '--k');
semilogx(w_pd2/2/pi/1e9, tau_pd2/1e-12, '--b');
semilogx(w_pd3/2/pi/1e9, tau_pd3/1e-12, '--r');
xlim([0, 100]);
xlabel('Frequency [GHz]');
ylabel('Group Delay [ps]');