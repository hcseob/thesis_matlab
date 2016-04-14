function p = pulse_from_h5(fname, L, offset)
if (nargin < 3); offset = 0; end;

hinfo = hdf5info(fname);
data = hdf5read(hinfo.GroupHierarchy.Groups(3).Groups(1).Datasets(1));
Ncycles = floor(length(data)/L);
p.ps = reshape(data(1:L*Ncycles), L, Ncycles);
p.p = mean(p.ps, 2);
p.t = (0:L-1)*12.5e-12;

% center pulse
[~, max_ind] = max(abs(p.p-mean(p.p)));
shift = round((max_ind - L/2)/8)*8 + offset;
p.p = circshift(p.p, -shift);
p.ps = circshift(p.ps, -shift);

% normalize pulse
p.p_norm = p.p - p.p(1);
if abs(min(p.p_norm)) > abs(max(p.p_norm)); p.p_norm = -p.p_norm; end;
p.p_norm = p.p_norm/max(p.p_norm);

% calculate baud pulse
[~, max_ind] = max(p.p_norm);
n_start = mod(max_ind, 4)+4;
p.p_baud = p.p_norm(n_start:4:end);
p.t_baud = p.t(n_start:4:end);

end