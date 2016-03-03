clear all; close all;
run('~/thesis/matlab/thesis.m'); addpath('./lib');
load('../../data/channels/channels.mat');

%%
pulse = p_norm.nel2;
t = p_norm.t;

delay = 25e-12;
BW = 1e18;
coeffs = ones(5, 1);
[~, ps_pade1] = ffe_pade1(pulse, t, delay, BW, coeffs);

bits = 3;
amp_lim = 0.1;
c_pade1 = brute_force_pmr_opt(ps_pade1, bits, amp_lim);
[p_pade1, ps_pade1] = ffe_pade1(pulse, t, delay, BW, c_pade1);

% convert to bessel1
load('../delay_equiv/A.mat');
Aeval = subs(A, sym('a'), 0);
B = subs(A, sym('a'), 1);
M = double(Aeval^-1*B);

c_bessel1_M = M*c_pade1(end:-1:1); c_bessel1_M = c_bessel1_M(end:-1:1);
[p_bessel1_M, ps_bessel1] = ffe_bessel1(pulse, t, delay/2, BW, c_bessel1_M);

% find the opt for bessel1 
c_bessel1 = brute_force_pmr_opt(ps_bessel1, bits, amp_lim);
[p_bessel1, ps_bessel1] = ffe_bessel1(pulse, t, delay/2, BW, c_bessel1);

%% convert to pade1 with alpha = 1/3
alpha = 1/3;
Aeval = subs(A, sym('a'), alpha);
Ma = real(double(Aeval^-1*B));

c_pade1a_M = Ma*c_pade1(end:-1:1); c_pade1a_M = c_pade1a_M(end:-1:1);
[p_pade1a_M, ps_pade1a] = ffe_pade1(pulse, t, delay, BW, c_pade1a_M, alpha);

% find the opt for pade1a 
c_pade1a = brute_force_pmr_opt(ps_pade1a, bits, amp_lim);
[p_pade1a, ps_pade1a] = ffe_pade1(pulse, t, delay, BW, c_pade1a, alpha);

%%
figure; hold all;
plot(t/1e-12, pulse, '--k', 'linewidth', 1);
plot(t(12:50:end)/1e-12, pulse(12:50:end), 'ok', 'linewidth', 1);


plot(t/1e-12, p_pade1, '-k', 'linewidth', 2);
plot(t(24:50:end)/1e-12, p_pade1(24:50:end), 'ok', 'linewidth', 2);
% plot(t, p_bessel1_M, '--', 'linewidth', 2);
% plot(t, p_pade1a_M, '-x');

plot(t/1e-12, p_bessel1, '--', 'linewidth', 2, 'color', stanford_red);
plot(t(18:50:end)/1e-12, p_bessel1(18:50:end), 'o', 'linewidth', 2, 'color', stanford_red);
plot(t/1e-12, p_pade1a, '-.', 'linewidth', 2, 'color', new_blue);
plot(t(18:50:end)/1e-12, p_pade1a(18:50:end), 'o', 'linewidth', 2, 'color', new_blue);
xlim([0, 800]);
xlabel('Time [ps]', 'fontsize', 14);
ylabel('Amplitude', 'fontsize', 14);
set(gca, 'fontsize', 14);
print('-depsc', './figures/pade1_bessel1_equiv_pulse');

%%
disp([c_bessel1, c_bessel1_M]);

S = transpose(M)*M;
[V1, D1]= eig(S);
sN1 = sqrt(max(real(diag(D1))));
S = transpose(Ma)*Ma;
[V2, D2]= eig(S);
sN2 = sqrt(max(real(diag(D2))));
disp([sN1, sN2]);

sN1_actual = norm(c_bessel1_M)/norm(c_pade1);
sN2_actual = norm(c_pade1a_M)/norm(c_pade1);
disp([sN1_actual, sN2_actual]);

sN1_opt= norm(c_bessel1)/norm(c_pade1);
sN2_opt = norm(c_pade1a)/norm(c_pade1);
disp([sN1_opt, sN2_opt]);


%% TF comparison
bs1 = bessel_sys(1, delay/2);
pd1 = pade_sys(1, delay);
pd1a = pade_sys(1, delay, alpha);

pd_tf = 0;
for j = 1:length(c_pade1)
    pd_tf = pd_tf + pd1^(j-1)*c_pade1(j);
end

bs_tf = 0;
for j = 1:length(c_bessel1_M)
    bs_tf = bs_tf + bs1^(j-1)*c_bessel1_M(j);
end

bs_tf_opt = 0;
for j = 1:length(c_bessel1)
    bs_tf_opt = bs_tf_opt + bs1^(j-1)*c_bessel1(j);
end

pda_tf = 0;
for j = 1:length(c_pade1a_M)
    pda_tf = pda_tf + pd1a^(j-1)*c_pade1a_M(j);
end

pda_tf_opt = 0;
for j = 1:length(c_pade1a)
    pda_tf_opt = pda_tf_opt + pd1a^(j-1)*c_pade1a(j);
end

%%
f = logspace(8, 12, 25);
w = 2*pi*f;
[g_pd, p_pd] = bode(pd_tf, w);
[g_bs, p_bs] = bode(bs_tf, w);
[g_pda, p_pda] = bode(pda_tf, w);

[g_bs_opt, p_bs_opt] = bode(bs_tf_opt, w);
[g_pda_opt, p_pda_opt] = bode(pda_tf_opt, w);

figure;
subplot(211);
semilogx(f/1e9, db(squeeze(g_bs)), 'x', 'linewidth', 2, 'color', stanford_red, 'markersize', 12); hold all;
semilogx(f/1e9, db(squeeze(g_pda)), 'o', 'linewidth', 2, 'color', new_blue, 'markersize', 8);
semilogx(f/1e9, db(squeeze(g_pd)), '-k', 'linewidth', 2); 
ylim([-20, 10]);
xlabel('Frequency [GHz]', 'fontsize', 14)
ylabel('Magnitude [dB]', 'fontsize', 14);
set(gca, 'fontsize', 14);

subplot(212);
semilogx(f/1e9, squeeze(p_bs)-360, 'x', 'linewidth', 2, 'color', stanford_red, 'markersize', 12); hold all;
semilogx(f/1e9, squeeze(p_pda)-360, 'o', 'linewidth', 2, 'color', new_blue, 'markersize', 8);
semilogx(f/1e9, squeeze(p_pd)-360, '-k', 'linewidth', 2);
ylim([-300, 100]);
xlabel('Frequency [GHz]', 'fontsize', 14)
ylabel('Phase [deg]', 'fontsize', 14);
set(gca, 'fontsize', 14);
print('-depsc', './figures/pade1_bessel1_equiv_equal');

figure;
subplot(211);
semilogx(f/1e9, db(squeeze(g_bs_opt)), '-x', 'linewidth', 2, 'color', stanford_red, 'markersize', 12); hold all;
semilogx(f/1e9, db(squeeze(g_pda_opt)), '-o', 'linewidth', 2, 'color', new_blue, 'markersize', 8);
semilogx(f/1e9, db(squeeze(g_pd)), '-k', 'linewidth', 2);
ylim([-20, 10]);
xlabel('Frequency [GHz]', 'fontsize', 14)
ylabel('Magnitude [dB]', 'fontsize', 14);
set(gca, 'fontsize', 14);

subplot(212);
semilogx(f/1e9, squeeze(p_bs_opt), '-x', 'linewidth', 2, 'color', stanford_red, 'markersize', 12); hold all;
semilogx(f/1e9, squeeze(p_pda_opt), '-o', 'linewidth', 2, 'color', new_blue, 'markersize', 8);
semilogx(f/1e9, squeeze(p_pd)-360, '-k', 'linewidth', 2);
ylim([-300, 100]);
xlabel('Frequency [GHz]', 'fontsize', 14)
ylabel('Phase [deg]', 'fontsize', 14);
set(gca, 'fontsize', 14);
print('-depsc', './figures/pade1_bessel1_equiv_opt');


%% coeff spread (limit coeffs to +/- 1)
% atten_bs = 1/max(abs(c_bessel1_M));
% atten_pda = 1/max(abs(c_pade1a_M));
% 
% figure; hold all;
% plot(t, p_pade1);
% plot(t, p_pade1a_M*atten_pda);
% plot(t, p_bessel1_M*atten_bs);

