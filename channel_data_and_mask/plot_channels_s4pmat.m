clear all; close all; run('~/thesis/matlab/thesis.m'); addpath('./lib');
load('channels_from_s4p.mat');

figure; hold all;
plot(p.t, p.vid);
plot(p.t, p.ibm);
plot(p.t, p.nel0);
plot(p.t, p.nel1);
plot(p.t, p.nel2);
plot(p.t, p.nel3);

figure; hold all;
plot(IL.f/1e9, db(IL.ibm));
plot(IL.f/1e9, db(IL.nel0));
plot(IL.f/1e9, db(IL.nel1));
plot(IL.f/1e9, db(IL.nel2));
plot(IL.f/1e9, db(IL.nel3));

%%
L = 1500;
p_trunc.t = p.t(1:L);

N1 = 6801;
p_trunc.ibm = p.ibm(N1:N1+L-1);

[~, ind] = max(xcorr2(p.nel0, p_trunc.ibm)); N1 = ind - L;
p_trunc.nel0 = p.nel0(N1:N1+L-1);

[~, ind] = max(xcorr2(p.nel1, p_trunc.ibm)); N1 = ind - L;
p_trunc.nel1 = p.nel1(N1:N1+L-1);

[~, ind] = max(xcorr2(p.nel2, p_trunc.ibm)); N1 = ind - L;
p_trunc.nel2 = p.nel2(N1:N1+L-1);

[~, ind] = max(xcorr2(p.nel3, p_trunc.ibm)); N1 = ind - L;
p_trunc.nel3 = p.nel3(N1:N1+L-1);

figure; hold all;
plot(p_trunc.t, p_trunc.ibm);
plot(p_trunc.t, p_trunc.nel0);
plot(p_trunc.t, p_trunc.nel1);
plot(p_trunc.t, p_trunc.nel2);
plot(p_trunc.t, p_trunc.nel3);




%%
p_norm.t = p_trunc.t;
p_norm.ibm = p_trunc.ibm/max(p_trunc.ibm);
p_norm.nel0 = p_trunc.nel0/max(p_trunc.nel0);
p_norm.nel1 = p_trunc.nel1/max(p_trunc.nel1);
p_norm.nel2 = p_trunc.nel2/max(p_trunc.nel2);
p_norm.nel3 = p_trunc.nel3/max(p_trunc.nel3);

figure; hold all;
plot(p_norm.t, p_norm.ibm);
plot(p_norm.t, p_norm.nel0);
plot(p_norm.t, p_norm.nel1);
plot(p_norm.t, p_norm.nel2);
plot(p_norm.t, p_norm.nel3);

%%
save('channels.mat', 'IL', 'p', 'p_trunc', 'p_norm');

