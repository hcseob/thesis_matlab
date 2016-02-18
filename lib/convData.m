function x_out = convData(x, h)
x = x(:);
h = h(:);
x_len = length(x);
x = [x(end-length(h)+1:end); x]; % cyclic prefix

x_out = conv(x, h);
x_out = x_out(1+length(h):x_len+length(h));
end