clear all; close all; 
addpath('/home/rboesch/thesis/matlab/lib');
addpath('./lib');
%% create impulse responses
t_h = (1:500)*1e-12;
delta = 100e-12;

for k = 1:4
    RC = k*5e-12;
    h = exp(-(t_h-delta)/RC);
    hs(:, k) = convData(convData(convData(convData(convData(h, h), h), h), h), h);
    hs(:, k) = hs(:, k)/sum(hs(:, k));
end

plot_impresp = true;
if plot_impresp
    figure; hold all;
    plot(t_h/1e-12, hs(:, 1));
    plot(t_h/1e-12, hs(:, 2));
    plot(t_h/1e-12, hs(:, 3));
    plot(t_h/1e-12, hs(:, 4));
    xlim([0, 500]);
end

save('hs.mat', 't_h', 'hs');

%% create input sequence
x_bits = [-1, -1, -1, -1, 1, -1, -1, -1, -1, 1, -1, 1, -1, 1, 1, 1]';
for k = 1:length(x_bits)
    x_single_bit = zeros(length(x_bits), 1);
    x_single_bit(k) = x_bits(k);
    x_single_bit = repmat(x_single_bit, 3, 1);
    x_one = zoh_len(x_single_bit, 50);
    x_ones(:, k) = x_one;
end

x_bits = repmat(x_bits, 3, 1);
x = zoh_len(x_bits, 50);
t = (0:length(x)-1)'*1e-12;
save('x.mat', 't', 'x');

% %% convolve
% y = nan(length(x), 4);
% y(:, 1) = convData(x, hs(:, 1));
% y(:, 2) = convData(x, hs(:, 2));
% y(:, 3) = convData(x, hs(:, 3));
% y(:, 4) = convData(x, hs(:, 4));
% 
% for k = 1:size(x_ones, 2)
%     y_ones(:, k) = convData(x_ones(:, k), hs(:, 4));
% end
% 
% %% align
% ya = nan(length(x), 4);
% for k = 1:4
%     ya(:, k) = prbs_align(x, y(:, k));
% end
% 
% for k = 1:size(y_ones, 2)
%     y_onesa(:, k) = prbs_align(x_ones(:, k), y_ones(:, k));
% end
% 
% %% plot
% x_lim = [900, 1700];
% y_lim = [-1.1, 1.1];
% 
% figure; hold all;
% plot(t/1e-12, x, '-k', 'linewidth', 3);
% xlim(x_lim); ylim(y_lim); axis off;
% plot(t(25:50:end)/1e-12, x(25:50:end), 'ok', 'linewidth', 3);
% plot(t/1e-12, x, '-k', 'linewidth', 10);
% xlim(x_lim); ylim(y_lim); axis off;
% 
% for k = 1:4
%     figure; hold all;
%     plot(t/1e-12, ya(:, k), '-k', 'linewidth', 3);
%     xlim(x_lim); ylim(y_lim); axis off;
%     plot(t(30:50:end)/1e-12, ya(30:50:end, k), 'ok', 'linewidth', 3);
% 
%     plot(t/1e-12, ya(:, k), '-k', 'linewidth', 10);
%     xlim(x_lim); ylim(y_lim); axis off;
% end
% 
% %%
% os = 25;
% line_width = 10;
% marker_size = 10;
% file_format = '-depsc';
% for k = 9:12
%     figure; hold all;
%     plot(t/1e-12, x_ones(:, k), '-k', 'linewidth', line_width);
%     xlim(x_lim); ylim(y_lim);
%     axis off;
%     plot(t(os:50:end)/1e-12, x_ones(os:50:end, k), 'ok', 'linewidth', line_width, 'markersize', marker_size);
%     
%     figure; hold all;
%     plot(t/1e-12, y_onesa(:, k), '-k', 'linewidth', line_width);
%     xlim(x_lim); ylim(y_lim);
%     axis off;
%     plot(t(os:50:end)/1e-12, y_onesa(os:50:end, k), 'ok', 'linewidth',line_width, 'markersize', marker_size);
%     close all;
% end
% 
% %%
% figure; hold all;
% plot(t/1e-12, x_ones, '-k', 'linewidth', line_width);
% plot(t/1e-12, x, '--r', 'linewidth', line_width);
% xlim(x_lim); ylim(y_lim);
% axis off;
% print('-depsc', './figures/x_pulses');
% 
% figure; hold all;
% plot(t/1e-12, y_onesa, '-k', 'linewidth', line_width);
% plot(t/1e-12, ya(:, 4), '--r', 'linewidth', line_width);
% xlim(x_lim); ylim(y_lim);
% axis off;
% print('-depsc', './figures/y_pulses');



