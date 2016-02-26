clear all; close all; run('~/thesis/matlab/thesis.m'); addpath('./lib');
addpath('/cad/cadence/MMSIM10.11.128.lnx86/tools.lnx86/spectre/matlab/64bit');

%% time domain
p.t = 0:1e-12:10e-9;
data = cds_srr('/home/rboesch/simulation/Channel_s4p/spectre/schematic/psf','tran-tran','vod_ibm');
p.ibm = interp1(data.time, data.V, p.t);
save('channels_from_s4p.mat', 'p');

clear all;
load('channels_from_s4p.mat');
data = cds_srr('/home/rboesch/simulation/Channel_s4p/spectre/schematic/psf','tran-tran','vod_nel0');
p.nel0 = interp1(data.time, data.V, p.t);
save('channels_from_s4p.mat', 'p');

clear all;
load('channels_from_s4p.mat');
data = cds_srr('/home/rboesch/simulation/Channel_s4p/spectre/schematic/psf','tran-tran','vod_nel1');
p.nel1 = interp1(data.time, data.V, p.t);
save('channels_from_s4p.mat', 'p');

clear all;
load('channels_from_s4p.mat');
data = cds_srr('/home/rboesch/simulation/Channel_s4p/spectre/schematic/psf','tran-tran','vod_nel2');
p.nel2 = interp1(data.time, data.V, p.t);
save('channels_from_s4p.mat', 'p');

clear all;
load('channels_from_s4p.mat');
data = cds_srr('/home/rboesch/simulation/Channel_s4p/spectre/schematic/psf','tran-tran','vod_nel3');
p.nel3 = interp1(data.time, data.V, p.t);
save('channels_from_s4p.mat', 'p');

clear all;
load('channels_from_s4p.mat');
data = cds_srr('/home/rboesch/simulation/Channel_s4p/spectre/schematic/psf','tran-tran','vid');
p.vid = interp1(data.time, data.V, p.t);
save('channels_from_s4p.mat', 'p');

% plot all
figure; hold all;
plot(p.t, p.vid);
plot(p.t, p.ibm);
plot(p.t, p.nel0);
plot(p.t, p.nel1);
plot(p.t, p.nel2);
plot(p.t, p.nel3);

%% frequency domain
data = cds_srr('/home/rboesch/simulation/Channel_s4p/spectre/schematic/psf','ac-ac','vod_ibm');
IL.f = data.freq;
IL.ibm = data.V;

data = cds_srr('/home/rboesch/simulation/Channel_s4p/spectre/schematic/psf','ac-ac','vod_nel0');
IL.nel0 = data.V;

data = cds_srr('/home/rboesch/simulation/Channel_s4p/spectre/schematic/psf','ac-ac','vod_nel1');
IL.nel1 = data.V;

data = cds_srr('/home/rboesch/simulation/Channel_s4p/spectre/schematic/psf','ac-ac','vod_nel2');
IL.nel2 = data.V;

data = cds_srr('/home/rboesch/simulation/Channel_s4p/spectre/schematic/psf','ac-ac','vod_nel3');
IL.nel3 = data.V;

figure; hold all;
plot(IL.f/1e9, db(IL.ibm));
plot(IL.f/1e9, db(IL.nel0));
plot(IL.f/1e9, db(IL.nel1));
plot(IL.f/1e9, db(IL.nel2));
plot(IL.f/1e9, db(IL.nel3));

ylim([-40, 0])

save('channels_from_s4p.mat', 'p', 'IL');

