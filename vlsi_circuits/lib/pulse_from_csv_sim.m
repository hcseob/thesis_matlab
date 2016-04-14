function [ch, eq] = pulse_from_csv_sim(fname, eq_first)
if (nargin < 3); eq_first = 0; end

data = csvread(fname, 1, 0);

t = 7e-9:12.5e-12:11e-9;
ch.p = interp1(data(:, 1), data(:, 2), t);
ch.t = t - t(1);
eq.p = interp1(data(:, 3), data(:, 4), t);
eq.t = t - t(1);
if eq_first
    tmp = eq.p;
    eq.p = ch.p;
    ch.p = tmp;
end

ch = process_pulse(ch);
eq = process_pulse(eq);

end

function pout = process_pulse(p)
% center pulse
[~, max_ind] = max(abs(p.p-mean(p.p)));
shift = round(max_ind - length(p.p)/5);
pout.p = circshift(p.p, [0, -shift]);
pout.t = p.t;

% normalize pulse
pout.p_norm = pout.p - pout.p(1);
if abs(min(pout.p_norm)) > abs(max(pout.p_norm)); pout.p_norm = -pout.p_norm; end;
pout.p_norm = pout.p_norm/max(pout.p_norm);

% calculate baud pulse
[~, max_ind] = max(pout.p_norm);
n_start = mod(max_ind, 4)+4;
pout.p_baud = pout.p_norm(n_start:4:end);
pout.t_baud = pout.t(n_start:4:end);

end