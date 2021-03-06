clear all; close all; run('~/thesis/matlab/thesis.m'); addpath('./lib');
load('../../data/channels/channel_standards.mat');
load('../../data/channels/channels.mat');

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

plot(IL_db.f_GHz, -IL_db.bmcaui4, '--r');
plot(IL_db.f_GHz, -IL_db.bj100gbasekr4, '--r');
plot(IL_db.f_GHz, -IL_db.bj100gbasecr4, '--r');

figure; hold all;
plot(p_trunc.t, p_trunc.ibm);
plot(p_trunc.t, p_trunc.nel0);
plot(p_trunc.t, p_trunc.nel1);
plot(p_trunc.t, p_trunc.nel2);
plot(p_trunc.t, p_trunc.nel3);

figure; hold all;
plot(p_norm.t, p_norm.ibm);
plot(p_norm.t, p_norm.nel0);
plot(p_norm.t, p_norm.nel1);
plot(p_norm.t, p_norm.nel2);
plot(p_norm.t, p_norm.nel3);