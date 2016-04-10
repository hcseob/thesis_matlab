clear all; close all;
run('~/thesis/matlab/thesis.m'); addpath('./lib');
load('channels.mat');

os = 1; T = 50;
t = p_norm.t;
t_baud = p_norm.t(os:T:end);
nel0_baud = p_norm.nel0(os:T:end);
nel2_baud = p_norm.nel2(os:T:end);
nel1_baud = p_norm.nel1(os:T:end);
ibm_baud = p_norm.ibm(os:T:end);

tos = 150e-12;
h_t = @(kappa) 1/(pi*kappa)*((t-tos)/kappa+1)./(((t-tos)/kappa).^2+1);

kappa(1) = 30e-12;
h1 = h_t(kappa(1)); h1 = h1/max(h1);

figure; hold all;
plot(t/1e-12, p_norm.nel1, '-', 'color', 'k', 'linewidth', 3);
plot(t/1e-12, p_norm.nel0, '--', 'color', stanford_red, 'linewidth', 3);
plot(t/1e-12, p_norm.nel2, ':', 'color', new_blue, 'linewidth', 3);

plot(t/1e-12, h1, '--', 'color', new_blue, 'linewidth', 3);

plot(t_baud/1e-12, nel1_baud, 'o', 'linewidth', 2, 'color', 'k', 'markerfacecolor', 'k', 'markersize', 8);
plot(t_baud/1e-12, nel0_baud, 'o', 'linewidth', 2, 'color', stanford_red, 'markerfacecolor', stanford_red, 'markersize', 8);
plot(t_baud/1e-12, nel2_baud, 'o', 'linewidth', 2, 'color', new_blue, 'markerfacecolor', new_blue, 'markersize', 8);

set(gca, 'fontsize', 18);
xlabel('Time (ps)', 'fontsize', 18);
ylabel('Normalized Pulse Response', 'fontsize', 18);
xlim([0, 800]);
ylim([-0.2, 1.2]);
box on;
legend('0.76 m Meg', '0.76 m FR4', '1.09 m FR4');