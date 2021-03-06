function pade1_bessel1_equiv
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
plot(t/1e-12, pulse, '-k', 'linewidth', 1);
plot(t(12:50:end)/1e-12, pulse(12:50:end), 'ok', 'linewidth', 3, 'markersize', 8, 'markerfacecolor', 'k');


p1 = plot(t/1e-12, p_bessel1, '-k', 'linewidth', 3);
plot(t(18:50:end)/1e-12, p_bessel1(18:50:end), 'ok', 'linewidth', 3, 'markersize', 8, 'markerfacecolor', 'k');
p2 = plot(t/1e-12, p_pade1a, '--', 'linewidth', 3, 'color', stanford_red);
plot(t(18:50:end)/1e-12, p_pade1a(18:50:end), 'o', 'color', stanford_red, 'linewidth', 3, 'markersize', 8, 'markerfacecolor', stanford_red);
p3 = plot(t/1e-12, p_pade1, ':', 'linewidth', 3, 'color', new_blue);
plot(t(24:50:end)/1e-12, p_pade1(24:50:end), 'o', 'color', new_blue, 'linewidth', 3, 'markersize', 8, 'markerfacecolor', new_blue);
xlim([0, 400]);
ylim([-0.2, 1.2]);
box on;
xlabel('Time (ps)', 'fontsize', 18);
ylabel('Pulse Response', 'fontsize', 18);
set(gca, 'fontsize', 18);
legend([p1, p2, p3], 'a = 0', 'a = 1/3', 'a = 1');
text(100, 1.05, 'After Channel', 'fontsize', 18);
text(200, 0.1, 'After FFE', 'fontsize', 18);
save_fig('./figures/pade1_bessel1_equiv_pulse.eps');

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
semilogx(f/1e9, db(squeeze(g_pd)), '-k', 'linewidth', 3); hold all;
semilogx(f/1e9, db(squeeze(g_bs)), '--', 'linewidth', 3, 'color', stanford_red);
semilogx(f/1e9, db(squeeze(g_pda)), ':', 'linewidth', 3, 'color', new_blue);
xlim([0.1, 1000]);
ylim([-20, 10]);
xlabel('Frequency (GHz)', 'fontsize', font_size_label)
ylabel('Magnitude (dB)', 'fontsize', font_size_label);
set(gca, 'fontsize', font_size);

subplot(212);
semilogx(f/1e9, squeeze(p_pd)-360, '-k', 'linewidth', 3); hold all;
semilogx(f/1e9, squeeze(p_bs)-360, '--', 'linewidth', 3, 'color', stanford_red);
semilogx(f/1e9, squeeze(p_pda)-360, ':', 'linewidth', 3, 'color', new_blue);
xlim([0.1, 1000]);
ylim([-300, 100]);
legend('a = 0', 'a = 1/3', 'a = 1', 'location', 'southwest'); 
xlabel('Frequency (GHz)', 'fontsize', font_size_label)
ylabel('Phase (Degrees)', 'fontsize', font_size_label);
set(gca, 'fontsize', font_size);
save_fig('./figures/pade1_bessel1_equiv_equal.eps');

figure;
subplot(211);
semilogx(f/1e9, db(squeeze(g_pd)), '-k', 'linewidth', 3); hold all;
semilogx(f/1e9, db(squeeze(g_bs_opt)), '--', 'linewidth', 3, 'color', stanford_red);
semilogx(f/1e9, db(squeeze(g_pda_opt)), ':', 'linewidth', 3, 'color', new_blue);
xlim([0.1, 1000]);
ylim([-20, 10]);
xlabel('Frequency (GHz)', 'fontsize', font_size_label)
ylabel('Magnitude (dB)', 'fontsize', font_size_label);
set(gca, 'fontsize', font_size);

subplot(212);
semilogx(f/1e9, squeeze(p_pd)-360, '-k', 'linewidth', 3); hold all;
semilogx(f/1e9, squeeze(p_bs_opt), '--', 'linewidth', 3, 'color', stanford_red);
semilogx(f/1e9, squeeze(p_pda_opt), ':', 'linewidth', 3, 'color', new_blue);
xlim([0.1, 1000]);
ylim([-300, 100]);
legend('a = 0', 'a = 1/3', 'a = 1', 'location', 'southwest'); 
xlabel('Frequency (GHz)', 'fontsize', font_size_label)
ylabel('Phase (Degrees)', 'fontsize', font_size_label);
set(gca, 'fontsize', font_size);
save_fig('./figures/pade1_bessel1_equiv_opt.eps');

end
