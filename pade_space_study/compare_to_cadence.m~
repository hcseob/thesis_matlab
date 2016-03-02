clear all; close all;
%% delay_time_sweep_2_taps
clear all;
% matlab
load('delay_time_sweep_2_taps.mat');
k = 14;
delay = delays(k);
coeffs = c_nel2(:, k);
disp(coeffs);
disp(delay/1e-12);

pulse = p_norm.nel2;
t = p_norm.t;
BW = 1e15;
[pout, ps] = ffe_pade1(pulse, t, delay, BW, coeffs);

% cadence
addpath('/cad/cadence/MMSIM10.11.128.lnx86/tools.lnx86/spectre/matlab/64bit');
data = cds_srr('/home/rboesch/simulation/PadeDelay1_FFE5_TB/spectre/schematic/psf', 'tran-tran', 'VO1');
p_cad = data.V;
t_cad = data.time;

% plots 
figure; hold all;
% plot(t, ps);
plot(t, pout);
plot(t_cad, p_cad);

%% delay_time_sweep_n_taps
clear all;
% matlab
load('delay_time_sweep_n_taps.mat');
k = 14;
delay = delays(k);
coeffs = c5(:, k);
disp(coeffs);
disp(delay/1e-12);

pulse = p_norm.nel2;
t = p_norm.t;
BW = 1e15;
[pout, ps] = ffe_pade1(pulse, t, delay, BW, coeffs);

% cadence
addpath('/cad/cadence/MMSIM10.11.128.lnx86/tools.lnx86/spectre/matlab/64bit');
data = cds_srr('/home/rboesch/simulation/PadeDelay1_FFE5_TB/spectre/schematic/psf', 'tran-tran', 'VO2');
p_cad = data.V;
t_cad = data.time;

% plots 
figure; hold all;
% plot(t, ps);
plot(t, pout);
plot(t_cad, p_cad);

%% amplitude_sweep
clear all;
% matlab
load('amplitude_sweep.mat');
k = 14;
amp = amp_lim(k);
coeffs = c5(:, k);
disp(coeffs);
disp(amp);

delay = 25e-12;
pulse = p_norm.nel2;
t = p_norm.t;
BW = 1e15;
[pout, ps] = ffe_pade1(pulse, t, delay, BW, coeffs);

% cadence
addpath('/cad/cadence/MMSIM10.11.128.lnx86/tools.lnx86/spectre/matlab/64bit');
data = cds_srr('/home/rboesch/simulation/PadeDelay1_FFE5_TB/spectre/schematic/psf', 'tran-tran', 'VO3');
p_cad = data.V;
t_cad = data.time;

% plots 
figure; hold all;
% plot(t, ps);
plot(t, pout);
plot(t_cad, p_cad);


%% bit_res_sweep
clear all;
% matlab
load('bit_res_sweep.mat');
k = 1;
bits = bitss(k);
coeffs = c5(:, k);
disp(coeffs);
disp(bits);

delay = 25e-12;
pulse = p_norm.nel2;
t = p_norm.t;
BW = 1e15;
[pout, ps] = ffe_pade1(pulse, t, delay, BW, coeffs);

% cadence
addpath('/cad/cadence/MMSIM10.11.128.lnx86/tools.lnx86/spectre/matlab/64bit');
data = cds_srr('/home/rboesch/simulation/PadeDelay1_FFE5_TB/spectre/schematic/psf', 'tran-tran', 'VO4');
p_cad = data.V;
t_cad = data.time;

% plots 
figure; hold all;
% plot(t, ps);
plot(t, pout, '-k');
plot(t(1:50:400), pout(1:50:400), 'ok');
plot(t_cad, p_cad);

%% bandwidth_sweep
clear all;
% matlab
load('BW_sweep.mat');
k = 8;
BW = BWs(k);
coeffs = c5(:, k);
disp(coeffs);
disp(BW);

delay = 25e-12;
pulse = p_norm.nel2;
t = p_norm.t;
[pout, ps] = ffe_pade1(pulse, t, delay, BW, coeffs);

% cadence
addpath('/cad/cadence/MMSIM10.11.128.lnx86/tools.lnx86/spectre/matlab/64bit');
data = cds_srr('/home/rboesch/simulation/PadeDelay1_FFE5_TB/spectre/schematic/psf', 'tran-tran', 'VO5');
p_cad = data.V;
t_cad = data.time;

% plots 
figure; hold all;
% plot(t, ps);
plot(t, pout);
plot(t_cad, p_cad);


