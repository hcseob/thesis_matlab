clear all; close all; addpath('./lib');
stanford_red = [140, 21, 21]/255;

% load sinusoid simulation results
load('../../data/simulation/sinusoid_power_sweep.mat');
vidi = vid(10002:end, :);
vodi = vod(10002:end, :);
ti = t(10002:end, :)-t(10002, :);
powers = relative_power;

% load prbs simulation results
load('../../data/simulation/prbs_power_sweep.mat');
L = 254 * 50;
vidp = vid(end-L+1:end, :);
vodp = vod(end-L+1:end, :);
tp = t(end-L+1:end, :)-t(end-L+1, :);
powers_prbs = relative_power;

%%
for k = 1:5
    % sinusoidal sdr calculation
    x = vidi(:, k);
    y = vodi(:, k);
    
    [hm, sm, dm] = calc_hysd_matrix(x, y, 2);
    sdr_matrix = var(sm)/var(dm);
       
    N = length(y);
    x_fft = fft(x)/(N/2); x_fft = x_fft(1:N/2);
    y_fft = fft(y)/(N/2); y_fft = y_fft(1:N/2);
    freq = (0:N/2-1)*100e6;
    sdr_fft = (abs(y_fft(2).^2)/2)/sum(abs(y_fft(3:end).^2/2));

    a1 = abs(y_fft(2)/x_fft(2));
    a3 = abs(y_fft(4)/x_fft(2)^3);
    
    [sdr_fft, sdr_matrix];
    sdr_sinusoid_sv(k) = sdr_matrix;
    
    % prbs sdr calculation
    x = vidp(:, k);
    y = vodp(:, k);
    t = tp;
    
    [hm, sm, dm] = calc_hysd_matrix(x, y, 1000);
    
%     edge_shifts = [0, 1, 1, -1]*1e-12 - 180e-12;
%     [hm, sm, dm, xm] = lms_hsd(t, y, 50e-12, edge_shifts, 4000, 2e-3, 100, false);
    sdr_lms = var(sm)/var(dm)
    sdr_prbs_sv(k) = sdr_lms;
end

%%
figure;
p1 = semilogx(powers/1e-3, 10*log10(sdr_sinusoid_sv), '-k', 'linewidth', 3); hold all;
semilogx([powers(5)/1e-3/10, powers(5)/1e-3], (10*log10(sdr_sinusoid_sv(5))+[20,0]), '--k', 'linewidth', 2);
p2 = semilogx(powers/1e-3, 10*log10(sdr_prbs_sv), '-', 'linewidth', 3, 'color', stanford_red); hold all;
semilogx([powers(5)/1e-3/10, powers(5)/1e-3], (10*log10(sdr_prbs_sv(5))+[20,0]), '--', 'linewidth', 2, 'color', stanford_red);
plot(powers(5)/1e-3, 34.8, 'o', 'linewidth', 2, 'color', stanford_red, 'markerfacecolor', stanford_red, 'markersize', 8);
% grid on;
set(gca, 'fontsize', 18);
xlabel('Input Signal Variance', 'fontsize', 18);
ylabel('SDR', 'fontsize', 18);
legend([p1, p2], {'Sinusoid', 'PRBS'});
xlim([1, 10]);
box on;
save_fig('./figures/sine_prbs_compare.eps');
%%
k = 5; n = 5;
xs = vidi(:, k);
ys = xs.^n;
as = mean(xs.*ys)/mean(xs.^2);
ds = var(ys-as*xs);

xp = vidp(:, k);
yp = xp.^n;
ap = mean(xp.*yp)/mean(xp.^2);
dp = var(yp-ap*xp);

disp(10*log10(dp/ds));

%%
sine_in = vidi(:, 5);
prbs_in = vidp(:, 5);

for k = 2:7
    alpha_prbs = mean(prbs_in.^(k+1))/mean(prbs_in.^2);
    alpha_sine = mean(sine_in.^(k+1))/mean(sine_in.^2);
    sdr_shift(k-1) = 20*log10(std(prbs_in.^k-alpha_prbs*prbs_in)/std(sine_in.^k-alpha_sine*sine_in));
    sdr_shift_nogaincorr(k-1) = 20*log10(std(prbs_in.^k)/std(sine_in.^k));
end

sdr_shift
sdr_shift_nogaincorr