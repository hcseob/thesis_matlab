clear all; close all; run('~/thesis/matlab/thesis.m'); addpath('./lib');
load('../../data/channels/channels.mat');

f = IL.f/1e9;
IL_db.bmcaui4 = 1.083 + 2.543*sqrt(f(f<12.89)) + 0.761*f(f<12.89);
IL_db.bmcaui4 = [IL_db.bmcaui4; -17.851 + 2.936*f(f>=12.89)];

IL_db.bj100gbasekr4 = 1.5 + 4.6*sqrt(f(f<12.89)) + 1.318*f(f<12.89);
IL_db.bj100gbasekr4 = [IL_db.bj100gbasekr4; -12.71 + 3.7*f(f>=12.89)];

IL_db.bj100gbasecr4 = (1.5 + 4.6*sqrt(f) + 1.318*f)*22.5/35;

figure; hold all;
plot(f, -IL_db.bmcaui4);
plot(f, -IL_db.bj100gbasekr4);
plot(f, -IL_db.bj100gbasecr4);
plot([0, 12.89], [1, 1]*-22.5, '--k');
plot([0, 12.89], [1, 1]*-35, '--k');
plot([12.89, 12.89], [-80, -22.5], '--k');
% xlim([0, 6])
IL_db.f_GHz = f;

save('channel_standards.mat', 'IL_db');