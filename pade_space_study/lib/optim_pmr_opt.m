function c_opt = optim_pmr_opt(ps, threshold, x0)
num_taps = size(ps, 2);
if nargin < 3 
    x0 = zeros(num_taps-1, 1);
else
    x0 = x0([1, 3:num_taps]);
end

Ap = ps(:, [1, 3:num_taps]);
bp = ps(:, 2);
pmr = @(p) sum(abs(p))/max(p);
create_pulse = @(x) Ap*x+bp;
fun = @(x) pmr(create_pulse(x));

force_equal = true;
if force_equal
    nonlcon = @(x) deal([], threshold - max(create_pulse(x)));
else
    nonlcon = @(x) deal(threshold - max(create_pulse(x)), []);
end

lb = -ones(num_taps-1, 1);
ub = +ones(num_taps-1, 1);

Aeq = [];
beq = [];
A = [];
b = [];

options = optimset('MaxFunEvals', 10000, ...
                   'Algorithm', 'active-set', ...
                   'Display', 'none');

x = fmincon(fun, x0, A, b, Aeq, beq, ...
                       lb, ub, nonlcon, options);

c_opt = [x(1); 1; x(2:end)];
end