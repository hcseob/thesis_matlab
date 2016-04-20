function [h, s, d, x] = lms_hsd(t, y, T, edge_shifts, h_len, step_size, num_loops, varargin)
if nargin > 7
    prbs_fit = varargin{1};
else
    prbs_fit = true;
end
x = ideal_data_edges(t, y, T, edge_shifts(1), edge_shifts(2), edge_shifts(3), edge_shifts(4), prbs_fit);    
y = y(:);

lms2 = dsp.LMSFilter(h_len, 'StepSize', step_size);
for k = 1:num_loops
    [s, d, h] = step(lms2, x, y);
end