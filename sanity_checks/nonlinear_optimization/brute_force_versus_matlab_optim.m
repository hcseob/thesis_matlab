clear all; close all;
run('~/thesis/matlab/thesis.m');
addpath('../../pade_space_study/lib');
load('../../../data/channels/channels.mat');

p = p_norm.nel2;
t = p_norm.t;

order = 2; 
delay = 25e-12;
num_taps = 5;
delay_cell = pade_sys(order, delay);
for j = 1:num_taps
    ps(:, j) = lsim((delay_cell)^(j-1), p, t);
end

run_brute_force = false;
if run_brute_force
    c = brute_force_pmr_opt(ps, 4, 0.5);
    save('brute_force_results.mat');
else
    load('brute_force_results.mat');
end
p_eq = ps*c;
amp_bf = max(p_eq);
[pmr_bf, os_opt] = pmr_best_offset(p_eq);

figure;
plot(t, ps);
plot(t, p_eq);


%%
Ap = ps(:, [1, 3, 4, 5]);
bp = ps(:, 2);
pmr = @(p) sum(abs(p))/max(p);
create_pulse = @(x) Ap*x+bp;
fun = @(x) pmr(create_pulse(x));
nonlcon = @(x) deal(0.5 - max(create_pulse(x)), []);
% function verification
disp([pmr(p_eq(1+os_opt:50:end)), 1/pmr_bf]);
disp([fun(c([1, 3, 4, 5])), pmr(p_eq)]);


lb = -ones(4, 1);
ub = +ones(4, 1);

Aeq = [];
beq = [];

A = [];
b = [];

x0 = zeros(4, 1);

options = optimset('MaxFunEvals', 1000);

[x, fval] = fmincon(fun, x0, A, b, Aeq, beq, lb, ub, nonlcon, options);

c_optim = [x(1); 1; x(2:end)];

%%

p_eq_optim = ps*c_optim;

1/pmr_best_offset(p_eq_optim)
1/pmr_best_offset(p_eq)

%%
c_test = optim_pmr_opt(ps, 0.5);

[c, c_optim, c_test]
