clear all; close all;
run('~/thesis/matlab/thesis.m'); addpath('./lib');
addpath('/cad/cadence/MMSIM10.11.128.lnx86/tools.lnx86/spectre/matlab/64bit');

N = 1024;
data = cds_srr('/home/rboesch/simulation/GainStageNL_Verify/spectre/schematic/psf', 'tran-tran', 'VO');
t = data.time(end-N:end-1);
vo = data.V(end-N:end-1);

save('gain_stage_nonlinearity.mat');

%%
clear all; close all;
addpath('/cad/cadence/MMSIM10.11.128.lnx86/tools.lnx86/spectre/matlab/64bit');
load('gain_stage_nonlinearity.mat');
data = cds_srr('/home/rboesch/simulation/GainStageNL_Verify/spectre/schematic/psf', 'tran-tran', 'VI');
t = data.time(end-N:end-1);
vi = data.V(end-N:end-1);
save('gain_stage_nonlinearity.mat');

%%
clear all; close all;
addpath('/cad/cadence/MMSIM10.11.128.lnx86/tools.lnx86/spectre/matlab/64bit');
load('gain_stage_nonlinearity.mat');
data = cds_srr('/home/rboesch/simulation/GainStageNL_Verify/spectre/schematic/psf', 'tran-tran', 'IO1');
t = data.time(end-N:end-1);
io1 = data.V(end-N:end-1);
save('gain_stage_nonlinearity.mat');

%%
clear all; close all;
addpath('/cad/cadence/MMSIM10.11.128.lnx86/tools.lnx86/spectre/matlab/64bit');
load('gain_stage_nonlinearity.mat');
data = cds_srr('/home/rboesch/simulation/GainStageNL_Verify/spectre/schematic/psf', 'tran-tran', 'IO2');
t = data.time(end-N:end-1);
io2 = data.V(end-N:end-1);
save('gain_stage_nonlinearity.mat');

t = t - t(1);
Amp = max(vi);

%%
Vi = fft(vi)/(N/2);
Vo = fft(vo)/(N/2);
a1 = real(Vo(2))/Amp;
a2 = real(Vo(3))/(Amp^2/2);
a3 = real(Vo(4))/(Amp^3/4);

% calc coeffs
G20 = -0.1e-3;
G01 = 0.3e-3;
G10 = 1.2e-3;
G11 = -234e-6;
G02 = 112e-6;

G30 = 100e-6;
G21 = -279e-6;
G12 = 405e-6;
G03 = -643e-6;

B = (G10-G01)/(G10+G01);

a1c = -1;
a2c = -G20/G10*(1+B)+G11/G10*(1-B)-G02/G10*(1+B);
a3c = (2*B*G20/G10 + (2*B-1)*G11/G10 + 2*(B+1)*G02/G10)*a2c;
a3c = a3c - (1-B)*G30/G10 + (1+B)*G21/G10 - (1-B)*G12/G10 + (1+B)*G03/G10;
disp([a1c, a1]);
disp([a2c, a2]);
disp([a3c, a3]);

%%
voc = a1c*vi+a2c*vi.^2+a3c*vi.^3;
a4c = (vo(:)-voc(:))/vi(:).^4;
voc = a1c*vi+a2c*vi.^2+a3c*vi.^3+a4c*vi.^3;
figure; hold all;
plot(t, vo-voc);

%%
io1c = G10*vi+G01*vo+G20*vi.^2;
io2c = (G10*vo+G01*vo+G20*vo.^2)*B;
figure; hold all;
plot(t, io1-io1c);
plot(t, io2-io2c);
plot(t, io1+io2);
% plot(t, io1c);


