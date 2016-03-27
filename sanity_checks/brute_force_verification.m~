clear all; close all;
addpath('./lib');
addpath('../pade_space_study/lib');
run('~/thesis/matlab/thesis.m');
load('../../data/channels/channels.mat');

p = p_norm.nel2;
t = p_norm.t;

num_taps = 5;
delay_cell = pade_sys(1, 25e-12);
for j = 1:num_taps
    ps(:, j) = lsim((delay_cell)^(j-1), p, t);
end


threshold = 0.5;
for N = 2.^(1:5)
    disp(N);
    c_opt = brute_force(ps, N, threshold);

    figure(1);
    plot(t, ps*c_opt); hold all;
end