function [coeffs_opt, pmr_opt, p_opt] = optim_pmr_opt(ps, threshold)
num_taps = size(ps, 2);
Ap = ps(:, [1, 3:num_taps]);
bp = ps(:, 2);
pmr = @(p) sum(abs(p))/max(p);
create_pulse = @(x) Ap*x+bp;
fun = @(x) pmr(create_pulse(x));
nonlcon = @(x) deal(threshold - max(create_pulse(x)), []);

lb = -ones(num_taps-1, 1);
ub = +ones(num_taps-1, 1);

Aeq = [];
beq = [];
A = [];
b = [];

x0 = zeros(num_taps-1, 1);

options = optimset('MaxFunEvals', 10000, 'Algorithm', 'active-set', 'Display', 'none');

[x, pmr_opt] = fmincon(fun, x0, A, b, Aeq, beq, lb, ub, nonlcon, options);

coeffs_opt = [x(1); 1; x(2:end)];
p_opt = ps*coeffs_opt;
end