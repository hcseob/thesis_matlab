function x = zoh(t_bits,x_bits,t)
if size(x_bits,2) > size(x_bits,1) % if row vector
    x_bits = transpose(x_bits);
end
if size(t,2) > size(t,1) % if row vector
    t = transpose(t);
end
if size(t_bits,2) > size(t_bits,1) % if row vector
    t_bits = transpose(t_bits);
end

x_bits = [x_bits(1);x_bits;x_bits(end)];
t_bits = [-inf;t_bits;inf];
[~,Iref] = histc(t,t_bits);
x = nan(size(t,1),1);
x(Iref>0) = x_bits(Iref(Iref>0));
