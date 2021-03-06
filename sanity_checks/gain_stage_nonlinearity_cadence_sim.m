clear all; close all;
run('~/thesis/matlab/thesis.m'); addpath('./lib');
addpath('/cad/cadence/MMSIM10.11.128.lnx86/tools.lnx86/spectre/matlab/64bit');

N = 1024;
data = cds_srr('/home/rboesch/simulation/TaylorExtract/spectre/schematic/psf', 'tran-tran', 'VO');
t = data.time(end-N:end-1);
vo = data.V(end-N:end-1);

save('gain_stage_nonlinearity_cadence_sim.mat');

%%
clear all; close all;
addpath('/cad/cadence/MMSIM10.11.128.lnx86/tools.lnx86/spectre/matlab/64bit');
load('gain_stage_nonlinearity_cadence_sim.mat');
data = cds_srr('/home/rboesch/simulation/TaylorExtract/spectre/schematic/psf', 'tran-tran', 'VI');
t = data.time(end-N:end-1);
vi = data.V(end-N:end-1);
save('gain_stage_nonlinearity_cadence_sim.mat');

%%
clear all; close all;
addpath('/cad/cadence/MMSIM10.11.128.lnx86/tools.lnx86/spectre/matlab/64bit');
load('gain_stage_nonlinearity_cadence_sim.mat');
data = cds_srr('/home/rboesch/simulation/TaylorExtract/spectre/schematic/psf', 'tran-tran', 'IO1');
t = data.time(end-N:end-1);
io1 = data.V(end-N:end-1);
save('gain_stage_nonlinearity_cadence_sim.mat');

%%
clear all; close all;
addpath('/cad/cadence/MMSIM10.11.128.lnx86/tools.lnx86/spectre/matlab/64bit');
load('gain_stage_nonlinearity_cadence_sim.mat');
data = cds_srr('/home/rboesch/simulation/TaylorExtract/spectre/schematic/psf', 'tran-tran', 'IO2');
t = data.time(end-N:end-1);
io2 = data.V(end-N:end-1);
save('gain_stage_nonlinearity_cadence_sim.mat');

t = t - t(1);
Amp = 20e-3;

%%
Vi = fft(vi)/(N/2);
Vo = fft(vo)/(N/2);
a1 = real(Vo(2))/Amp;
a2 = real(Vo(3))/(Amp^2/2);
a3 = real(Vo(4))/(Amp^3/4);

%%
Io1 = fft(io1)/(N/2);
Io2 = fft(io2)/(N/2);

% calc G1
G1 = nan(4, 4);
G1(2, 1) = real(Io1(2))/Amp;
G1(3, 1) = real(Io1(3))/(Amp^2/2);
G1(4, 1) = real(Io1(4))/(Amp^3/4);

G1(2, 2) = real(Io1(12))/(Amp^2/2);
G1(2, 3) = real(Io1(22))/(Amp^3/4);
G1(3, 2) = real(Io1(13))/(Amp^3/4);

G1(1, 2) = real(Io1(11))/Amp;
G1(1, 3) = real(Io1(21))/(Amp^2/2);
G1(1, 4) = real(Io1(31))/(Amp^3/4);

io1c = 0;
for j = 1:4
    for k = 1:4
        if ~isnan(G1(j, k))
            io1c = io1c + G1(j, k)*vic.^(j-1).*voc.^(k-1);
        end
    end
end

Io1c = fft(io1c)/(N/2);

% calc G2
G2 = nan(4, 4);
G2(2, 1) = real(Io2(2))/Amp;
G2(3, 1) = real(Io2(3))/(Amp^2/2);
G2(4, 1) = real(Io2(4))/(Amp^3/4);

G2(2, 2) = real(Io2(12))/(Amp^2/2);
G2(2, 3) = real(Io2(22))/(Amp^3/4);
G2(3, 2) = real(Io2(13))/(Amp^3/4);

G2(1, 2) = real(Io2(11))/Amp;
G2(1, 3) = real(Io2(21))/(Amp^2/2);
G2(1, 4) = real(Io2(31))/(Amp^3/4);


vic = Amp*cos(2*pi*(0:N-1)/N);
voc = Amp*cos(2*pi*10*(0:N-1)/N);

io2c = 0;
for j = 1:4
    for k = 1:4
        if ~isnan(G2(j, k))
            io2c = io2c + G2(j, k)*vic.^(j-1).*voc.^(k-1);
        end
    end
end

Io2c = fft(io2c)/(N/2);


figure; hold all;
plot(db(Io1), '-ok')
plot(db(Io1c), '--or')
xlim([0, 40])

figure; hold all;
plot(db(Io2), '-ok')
plot(db(Io2c), '--or')
xlim([0, 40])

%% beta concept
% worst case is for G21, others are pretty consistent
B = G2(2, 1)/G1(2, 1);
disp(G2./G1/B);


%% calc coeffs
Guse = G2;
G01 = Guse(1, 2);
G10 = Guse(2, 1);

G20 = Guse(3, 1);
G11 = Guse(2, 2);
G02 = Guse(1, 3);

G30 = Guse(4, 1);
G21 = Guse(3, 2);
G12 = Guse(2, 3);
G03 = Guse(1, 4);

B = G2(2, 1)/G1(2, 1);

a1c = -1;
a2c = -G20/G10*(1+B)+G11/G10*(1-B)-G02/G10*(1+B);
a3c = (2*B*G20/G10 + (2*B-1)*G11/G10 + 2*(B+1)*G02/G10)*a2c;
a3c = a3c - (1-B)*G30/G10 + (1+B)*G21/G10 - (1-B)*G12/G10 + (1+B)*G03/G10;

disp('[a1, a2, a3]');
disp([a1, a2, a3]);
disp('[a1c, a2c, a3c]');
disp([a1c, a2c, a3c]);

disp('Second order terms');
disp([-G20/G10*(1+B),G11/G10*(1-B),-G02/G10*(1+B)]);
disp('Third order terms (from second order)');
disp([(2*B*G20/G10)*a2c, ((2*B-1)*G11/G10)*a2c, (2*(B+1)*G02/G10)*a2c]);
disp('Third order terms');
disp([-(1-B)*G30/G10, (1+B)*G21/G10, -(1-B)*G12/G10, +(1+B)*G03/G10]);

% repeat for G1
Guse = G1;
G01 = Guse(1, 2);
G10 = Guse(2, 1);

G20 = Guse(3, 1);
G11 = Guse(2, 2);
G02 = Guse(1, 3);

G30 = Guse(4, 1);
G21 = Guse(3, 2);
G12 = Guse(2, 3);
G03 = Guse(1, 4);

B = G2(2, 1)/G1(2, 1);

a1c = -1;
a2c = -G20/G10*(1+B)+G11/G10*(1-B)-G02/G10*(1+B);
a3c = (2*B*G20/G10 + (2*B-1)*G11/G10 + 2*(B+1)*G02/G10)*a2c;
a3c = a3c - (1-B)*G30/G10 + (1+B)*G21/G10 - (1-B)*G12/G10 + (1+B)*G03/G10;

disp('[a1, a2, a3]');
disp([a1, a2, a3]);
disp('[a1c, a2c, a3c]');
disp([a1c, a2c, a3c]);


disp('Second order terms');
disp([-G20/G10*(1+B),G11/G10*(1-B),-G02/G10*(1+B)]);
disp('Third order terms (from second order)');
disp([(2*B*G20/G10)*a2c, ((2*B-1)*G11/G10)*a2c, (2*(B+1)*G02/G10)*a2c]);
disp('Third order terms');
disp([-(1-B)*G30/G10, (1+B)*G21/G10, -(1-B)*G12/G10, +(1+B)*G03/G10]);

%%
fout = fopen('gjk_values.txt', 'w');
fprintf(fout, '\n %.2f & %.2f & %.2f & %.2f \\\\ ', G1(1, :)/1e-3);
fprintf(fout, '\n %.2f & %.2f & %.2f & %.2f \\\\ ', G1(2, :)/1e-3);
fprintf(fout, '\n %.2f & %.2f & %.2f & %.2f \\\\ ', G1(3, :)/1e-3);
fprintf(fout, '\n %.2f & %.2f & %.2f & %.2f \\\\ \n', G1(4, :)/1e-3);

fprintf(fout, '\n %.2f & %.2f & %.2f & %.2f \\\\ ', G2(1, :)/1e-3);
fprintf(fout, '\n %.2f & %.2f & %.2f & %.2f \\\\ ', G2(2, :)/1e-3);
fprintf(fout, '\n %.2f & %.2f & %.2f & %.2f \\\\ ', G2(3, :)/1e-3);
fprintf(fout, '\n %.2f & %.2f & %.2f & %.2f \\\\ \n', G2(4, :)/1e-3);
fclose(fout);