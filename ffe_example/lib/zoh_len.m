function x = zoh_len(x_bits, os_len)
x_bits = x_bits(:);
x = repmat(x_bits', os_len, 1);
x = x(:);
end
