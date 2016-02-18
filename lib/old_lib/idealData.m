function y = idealData(t, x, period, varargin)
if nargin > 3
    prbsFit = varargin{1};
else
    prbsFit = false;
end
if nargin > 4
    dutyCycle = varargin{2};
    t_delay = (0.5 - dutyCycle) * period;
else
    t_delay = 0;
end

x_bits = dataToBits(t, x, period, prbsFit);
os = (max(x) + min(x))/2;
A = max(abs(x - os));
x_data = (2 * x_bits - 1) * A + os;
t_bits1 = [t(1)-period/100:period:t(end)-period/100];
duty_cycle_shift = x_bits;
duty_cycle_shift(2:2:end) = 0;
t_bits = t_bits1 + duty_cycle_shift * t_delay * 2;
% D = length(t_bits) - length(x_data);
% x_data = [x_data, ones(1,D)*x_data(end)]; % hold the last value for the extra t_bits value
y = zoh(t_bits,x_data,t);
end
