function y = ideal_data_edges(t, x, T, varargin)
x = x(:);
t = t(:);
if nargin > 3
    d_mean = mean([varargin{1:4}]);
    r1_shift = varargin{1} - d_mean;
    f1_shift = varargin{2} - d_mean;
    r2_shift = varargin{3} - d_mean;
    f2_shift = varargin{4} - d_mean;    
else
    r1_shift = 0;
    f1_shift = 0;
    r2_shift = 0;
    f2_shift = 0;
    d_mean = 0;
end
if nargin > 7
    prbs_fit = varargin{5};
else
    prbs_fit = true;
end

x_bits = data_to_bits(t, x, T, prbs_fit);
x_bits = [x_bits; x_bits(1)];

os = (max(x) + min(x))/2;
A = max(abs(x - os));
x_data = (2*x_bits - 1)*A + os;
t_bits = [t(1)-T/100:T:t(end)+T-T/100]';

rise_edges = diff(x_bits) > 0;
r1_edges = [0; rise_edges]; r1_edges(1:2:end) = 0;
r2_edges = [0; rise_edges]; r2_edges(2:2:end) = 0;
fall_edges = diff(x_bits) < 0;
f1_edges = [0; fall_edges]; f1_edges(1:2:end) = 0;
f2_edges = [0; fall_edges]; f2_edges(2:2:end) = 0;

t_bits = t_bits + d_mean + f1_shift*f1_edges + f2_shift*f2_edges + r1_shift*r1_edges + r2_shift*r2_edges;

y = zoh(t_bits, x_data, t);
end

function x_bits = data_to_bits(t, x, T, prbs_fit)
delay = find_delay(x, t, T);
os = (max(x) + min(x))/2;
t_bits = [t(1) + delay:T:t(end) + delay];
x_diff = diff(interp1(t, x, t_bits, 'linear', 'extrap'));

[counts, centers] = hist(abs(x_diff), 20);
[~, minInd] = min(counts(1:floor(length(counts)/2)));
threshold = centers(minInd);

x_bits = x_diff;
x_bits(abs(x_bits) < threshold) = 0; % no change
x_bits(x_bits < 0) = -1; % change to 0
x_bits(x_bits > 0) = 1; % change to 1
first_bit = (interp1(t, x, delay) > os)*2 - 1;
if x_bits(1) == 0 % if no change from first to second bits
    x_bits(1) = first_bit; % this is actually the second bit
end
for k = 2:length(x_bits)
    if x_bits(k) == 0 % if no change
        x_bits(k) = x_bits(k-1);
    end
end
x_bits = [first_bit, x_bits];
x_bits = x_bits > 0;

if prbs_fit
    x_bits = prbs_corr_fit(x_bits); 
end
x_bits = x_bits(:);
end

function delay = find_delay(x, t, T)
max_norm = 0;
for d = 0:1:9
    current_delay = d*T/10;
    current_norm = norm(interp1(t, x, [t(1) + current_delay:T:t(end)]));
    if current_norm > max_norm
        max_norm = current_norm;
        delay = current_delay;
    end
end
end

function x_bits = prbs_corr_fit(x_bits_in)
x_bits_in = x_bits_in(:);

prbs = [1;1;0;0;0;1;1;0;1;0;0;1;0;1;1;1;0;1;1;1;0;0;1;1;0;0;1;0;1;0;1; ...
        0;1;1;1;1;1;1;1;0;0;0;0;0;0;1;0;0;0;0;0;1;1;0;0;0;0;1;0;1;0;0; ...
        0;1;1;1;1;0;0;1;0;0;0;1;0;1;1;0;0;1;1;1;0;1;0;1;0;0;1;1;1;1;1; ...
        0;1;0;0;0;0;1;1;1;0;0;0;1;0;0;1;0;0;1;1;0;1;1;0;1;0;1;1;0;1;1; ...
        1;1;0;1;1;0;0;0;1;1;0;1;0;0;1;0;1;1;1;0;1;1;1;0;0;1;1;0;0;1;0; ...
        1;0;1;0;1;1;1;1;1;1;1;0;0;0;0;0;0;1;0;0;0;0;0;1;1;0;0;0;0;1;0; ...
        1;0;0;0;1;1;1;1;0;0;1;0;0;0;1;0;1;1;0;0;1;1;1;0;1;0;1;0;0;1;1; ...
        1;1;1;0;1;0;0;0;0;1;1;1;0;0;0;1;0;0;1;0;0;1;1;0;1;1;0;1;0;1;1; ...
        0;1;1;1;1;0];
    
max_corr = 0;
for k = 1:length(prbs)
    current_prbs = circshift(prbs, k);
    if length(x_bits_in) < length(prbs)
        current_corr = xcorr(x_bits_in, current_prbs(1:length(x_bits_in)), 0);
    else
        current_corr = xcorr(x_bits_in(1:length(prbs)), current_prbs, 0);
    end
    if abs(current_corr) > abs(max_corr)
        max_corr = current_corr;
        best_prbs = current_prbs;
    end
end

if max_corr < 0
    best_prbs = ~best_prbs;
end

% if ~isequal(best_prbs, x_bits_in(1:length(prbs)))
%     warning(strcat('did not find a perfect match with prbs1: matched ',num2str(sum(best_prbs.*x_bits_in))));
% end
N1 = length(x_bits_in);
N2 = length(best_prbs);
Q = floor(N1/N2);
x_bits = repmat(best_prbs, Q, 1);
R = N1 - length(x_bits);
x_bits = [x_bits, best_prbs(1:R)];
x_bits = x_bits(:);

end

function x = zoh(t_bits,x_bits,t)
t_bits = t_bits(:);
x_bits = x_bits(:);
t = t(:);
x_bits = [x_bits(1); x_bits; x_bits(end)];
t_bits = [-inf; t_bits; inf];
[~, iref] = histc(t, t_bits);
x = nan(size(t, 1), 1);
x(iref>0) = x_bits(iref(iref>0));
end
