clear all; close all; run('~/thesis/matlab/thesis.m'); addpath('./lib');
addpath('~/MATLAB/FFE/SID/functions');

%% Measured
load('~/thesis/data/first_chip/data/20150115/BOARD0.mat');
baudind = 4;
[prbs, t, prbs_s] = getBenchTran(COEFF, TIME, 6, baudind); 

figure;
plotEyeDiagram(t/1e-12, prbs, 50, 17);
xlim([0,50]);
ylim([-150e-3,150e-3]);
xlabel('Time (ps)', 'fontsize', 20);
ylabel('Voltage (V)', 'fontsize', 20);
set(gca, 'fontsize', 20);
set(gca, 'ytick', -150e-3:50e-3:150e-3);
box on;
save_fig('./figures/first_chip_measured.eps');

%% Pessimistic Simulation
load('~/thesis/data/first_chip/data/CadenceSimulations/trantran_SignalPath1FFEs_PRBS7_R1eq10R12eqR13eq20.mat');
[prbs_afs, t_afs] = getSimTran(trantran, 1, 'VOP3', 'VOM3');

figure;
plotEyeDiagram(t_afs/1e-12, -prbs_afs, 50, -5);
xlim([0,50]);
ylim([-150e-3,150e-3]);
xlabel('Time (ps)', 'fontsize', 20);
ylabel('Voltage (V)', 'fontsize', 20);
set(gca, 'fontsize', 20);
set(gca, 'ytick', -150e-3:50e-3:150e-3);
box on;
save_fig('./figures/first_chip_simulated_pessimistic.eps');

%% Realistic Simulation
load('~/thesis/data/first_chip/data/CadenceSimulations/trantran_SignalPath1FFEs_PRBS7_NewPDK.mat');
[prbs_afs, t_afs] = getSimTran(trantran, 1, 'VOP3', 'VOM3');

figure;
plotEyeDiagram(t_afs/1e-12, prbs_afs, 50, 31);
xlim([0,50]);
ylim([-150e-3,150e-3]);
xlabel('Time (ps)', 'fontsize', 20);
ylabel('Voltage (V)', 'fontsize', 20);
set(gca, 'fontsize', 20);
set(gca, 'ytick', -150e-3:50e-3:150e-3);
box on;
save_fig('./figures/first_chip_simulated_realistic.eps');

