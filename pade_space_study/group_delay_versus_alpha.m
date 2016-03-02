clear all; close all; run('~/thesis/matlab/thesis.m'); addpath('./lib');

delay = 25e-12;
alphas = logspace(-1, 1, 10);

for k = 1:length(alphas)
    alpha = alphas(k);
    pade1 = pade_sys(1, delay, alpha);
    [gain, phase, w] = bode(pade1);
    phase = squeeze(phase)*pi/180;
    
    w_gd = (w(1:end-1) + w(2:end))/2;
    group_delay = -diff(phase)./diff(w);
    group_delay_lfs(k) = group_delay(1);
    figure(1);
    semilogx(w_gd/2/pi, group_delay); hold all;
end

%%
figure;
plot(alphas, group_delay_lfs); hold all;
plot(alphas, (alphas+1)*delay/2, 'x');