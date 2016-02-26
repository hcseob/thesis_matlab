clear all; close all; run('~/thesis/matlab/thesis.m'); addpath('./lib');

f_GHz = logspace(-1, log10(30), 1000); 
IL_db = 1.083+2.543*sqrt(f_GHz)+0.761*f_GHz;
IL = 10.^(-IL_db/20);
f = 1e9*f_GHz;

% HF fit
f0 = f_GHz(end-1);
f1 = f_GHz(end);
y0 = IL_db(end-1);
y1 = IL_db(end);

m = (y1-y0)/(f1-f0);
b = y1 - m*f1;

IL_hf_db = m*f_GHz+b;
IL_hf = 10.^(-IL_hf_db/20);

figure; hold all;
plot(f, db(IL), '-'); hold all;
plot(f, db(IL_hf), '-'); hold all;

%% equalization
w0 = 2*pi*10e9;
w = 2*pi*f;
for k = 0.1:0.05:0.7
    Hs_mag = sqrt((1+w.^2/k^2/w0^2)./(1+w.^2/w0^2));
    plot(f, db(Hs_mag), '-'); hold all;
    plot(f, (db((w)/w0)+40)/2, '-'); hold all;
end

%% the three regions
k = 0.1;
wp = 2*pi*5e9;
wz = k*wp;
Hs_mag = sqrt((1+w.^2/wz^2)./(1+w.^2/wp^2));
Ha0 = 1*ones(size(w));
Ha1 = w/wz;
Ha2 = 1/k*ones(size(w));

figure;
semilogx(f, db(Hs_mag), '-'); hold all;
semilogx(f, db(Ha0), '--'); hold all;
semilogx(f, db(Ha1), '--'); hold all;
semilogx(f, db(Ha2), '--'); hold all;

