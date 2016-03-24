function [c, ceq] = amp_con(x)
load('brute_force_results.mat');
Ap = ps(:, [1, 3, 4, 5]);
bp = ps(:, 2);
create_pulse = @(x) Ap*[x(1); x(2); x(3); x(4)]+bp;
c = 0.5 - max(create_pulse(x)); % c < 0
ceq = [];