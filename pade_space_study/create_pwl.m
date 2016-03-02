clear all; close all;
run('~/thesis/matlab/thesis.m');
load('../../data/channels/channels.mat');

dlmwrite('pwl_nel2.csv', [p_norm.t', p_norm.nel2'], '\t');




