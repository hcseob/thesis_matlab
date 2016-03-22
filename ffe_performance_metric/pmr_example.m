clear all; close all; addpath('./lib');
run('~/thesis/matlab/thesis.m');

N = 11;
n = (1:N)';
ni = (1:0.1:N)';

sig = 0.8;
M = (N+1)/2;
pi = -normpdf(ni, M-0.9, sig)+2*normpdf(ni, M-0.1, sig) + normpdf(ni, M+0.6, sig);
pi = [normpdf(ni(ni<=M), M, 0.65)*0.65; normpdf(ni(ni>M), M, 1)];
pi = pi/max(pi);
p = interp1(ni, pi, n);

j = 1;
for k = -3:2
    ps(:, j) = circshift(p, k);
    pis(:, j) = circshift(pi, k*10);
    j = j+1;
end
p_post2 = circshift(p, -2);
p_post = circshift(p, -1);
p_pre = circshift(p, 1);
p_sum = p + p_post + p_pre;

pi_post2 = circshift(pi, -20);
pi_post = circshift(pi, -10);
pi_pre = circshift(pi, 10);
pi_sum = pi + pi_post + pi_pre;

%% pulse anatomy plot
ylims = [-0.2; 1.2];
figure; hold all;
plot(ni-M, pi, '-k', 'linewidth', 2);
plot(n-M, p, 'ok', 'linewidth', 2, 'markersize', 8, 'markerfacecolor', 'k');
plot(repmat(n-M, [1,2]), ylims, ':k');
xlim([-3.5, 3.5]);
ylim(ylims);
set(gca, 'fontsize', 18);
set(gca, 'xtick', -3:3);
% set(gca, 'ytick', []);
box on;
xlabel('UIs', 'fontsize', 18);
ylabel('Pulse Response', 'fontsize', 18);
text(0.1, 1.05, 'p[0]', 'fontsize', 18);
text(1.15, 0.6, 'p[1]', 'fontsize', 18);
text(2.15, 0.15, 'p[2]', 'fontsize', 18);
text(-2, 0.3, 'p[-1]', 'fontsize', 18);
text(-2.8, 0.08, 'p[-2]', 'fontsize', 18);
text(-1.2, 0.7, 'p(t)', 'fontsize', 18);
save_fig('./figures/pmr_example_pulse_anatomy.eps');


%% peak to main ratio plot
figure; hold all;
plot(0, ps(M, :), 'ok', 'linewidth', 2, 'markersize', 8, 'markerfacecolor', 'k');
plot(ni-M, pis, '-k');
plot(0, sum(ps(M, :)), 'ok', 'linewidth', 2, 'markersize', 8, 'markerfacecolor', 'k');
plot(ni-M, sum(pis, 2), '-k', 'linewidth', 2);
plot(n-M, ones(size(n)), '--k');
plot(n-M, ones(size(n))*sum(ps(M, :)), '--k');
plot([0, 0], [-0.5, 3], ':k');
xlim([1-M, N-M]);
ylim([-0.5, 3]);
set(gca, 'fontsize', 18);
set(gca, 'xtick', -5:5);
box on;
xlabel('UIs', 'fontsize', 18);
ylabel('Pulse Responses', 'fontsize', 18);


% text(3, 2.15, 'Peak', 'fontsize', 18);
% text(3, 1.1, 'Main', 'fontsize', 18);
text(-4.75, 2.15, 'Peak', 'fontsize', 18);
text(-4.75, 1.1, 'Main', 'fontsize', 18);
text(2.5, 1.5, 'r(t)', 'fontsize', 18);
text(0.2, 2.15, 'r[0] = p[-1]+p[0]+p[1]+p[2]', 'fontsize', 14);
text(0.2, 1, 'p[0]', 'fontsize', 14);
text(0.2, 0.6, 'p[1]', 'fontsize', 14);
text(0.2, 0.3, 'p[-1]', 'fontsize', 14);
text(0.2, 0.1, 'p[2]', 'fontsize', 14);
save_fig('./figures/pmr_example_summed_peak_main.eps');
