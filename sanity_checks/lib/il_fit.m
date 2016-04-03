function [a, fs, il_out] = il_fit(f, il)
il = db(il(:));
f = f(:);

f_GHz = f/1e9;
fs = [ones(length(f_GHz), 1), sqrt(f_GHz), f_GHz];

a = fs\abs(il);
il_out = fs*a;
end