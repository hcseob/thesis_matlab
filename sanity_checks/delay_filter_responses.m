clear all; close all;

f = logspace(-3, 3, 100);
w = 2*pi*f;
tau = 1;
s = 1j*w*tau;

pd1 = (1-1/2*s)./(1+1/2*s);
bs1 = 1./(1+s);

pd2 = (1-1/2*s+1/12*s.^2)./(1+1/2*s+1/12*s.^2);
bs2 = 3./(3+3*s+s.^2);

pd3 = (1-1/2*s+1/10*s.^2-1/120*s.^3)./(1+1/2*s+1/10*s.^2+1/120*s.^3);
bs3 = 15./(15+15*s+6*s.^2+s.^3);

% equiripple (need to adapt to correct delay...)
s2_1 = s/1.38;
s2_2 = s/1.45;
eq2_1 = 1.4638./(s2_1.^2+2.0175*s2_1+1.4638);
eq2_2 = 1.2251./(s2_2.^2+1.7179*s2_2+1.2251);

s3_1 = s/1.86;
s3_2 = s/1.94;
eq3_1 = 1.966./(s3_1.^3+2.7542*s3_1.^2+3.6664*s3_1+1.966);
eq3_2 = 1.4585./(s3_2.^3+2.2194*s3_2.^2+2.9172*s3_2+1.4585);

%% group delays
% calculate group delays
group_delay = @(H, w) -diff(phase(H))./diff(w);
f_tg = (f(1:end-1)+f(2:end))/2;
pd1_tg = group_delay(pd1, w);
pd2_tg = group_delay(pd2, w);
pd3_tg = group_delay(pd3, w);

bs1_tg = group_delay(bs1, w);
bs2_tg = group_delay(bs2, w);
bs3_tg = group_delay(bs3, w);

eq2_1_tg = group_delay(eq2_1, w);
eq3_1_tg = group_delay(eq3_1, w);

eq2_2_tg = group_delay(eq2_2, w);
eq3_2_tg = group_delay(eq3_2, w);

figure;
semilogx(f_tg, pd1_tg); hold all;
semilogx(f_tg, bs1_tg); hold all;

figure;
semilogx(f_tg, pd2_tg); hold all;
semilogx(f_tg, bs2_tg); hold all;
semilogx(f_tg, eq2_1_tg); hold all;
semilogx(f_tg, eq2_2_tg); hold all;

figure;
semilogx(f_tg, pd3_tg); hold all;
semilogx(f_tg, bs3_tg); hold all;
semilogx(f_tg, eq3_1_tg); hold all;
semilogx(f_tg, eq3_2_tg); hold all;


%% gain/phase vs frequency
% first order
figure;
subplot(211);
semilogx(f, db(pd1)); hold all;
semilogx(f, db(bs1));

subplot(212);
semilogx(f, phase(pd1)*180/pi); hold all;
semilogx(f, phase(bs1)*180/pi);

% second order
figure;
subplot(211);
semilogx(f, db(pd2)); hold all;
semilogx(f, db(bs2));
semilogx(f, db(eq2_1));
semilogx(f, db(eq2_2));

subplot(212);
semilogx(f, phase(pd2)*180/pi); hold all;
semilogx(f, phase(bs2)*180/pi);
semilogx(f, phase(eq2_1)*180/pi);
semilogx(f, phase(eq2_2)*180/pi);

% third order
figure;
subplot(211);
semilogx(f, db(pd3)); hold all;
semilogx(f, db(bs3));
semilogx(f, db(eq3_1));
semilogx(f, db(eq3_2));

subplot(212);
semilogx(f, phase(pd3)*180/pi); hold all;
semilogx(f, phase(bs3)*180/pi);
semilogx(f, phase(eq3_1)*180/pi);
semilogx(f, phase(eq3_2)*180/pi);
