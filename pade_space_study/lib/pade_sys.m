function  sys = pade_sys(order, delay)
d = delay;
if order == 1
    num = [-d/2, 1];
    den = [+d/2, 1];
elseif order == 2
    num = [d^2/12, -d/2, 1];    
    den = [d^2/12, +d/2, 1];
else
    num = [-d^3/120, d^2/10, -d/2, 1];   
    den = [+d^3/120, d^2/10, +d/2, 1];   
end

sys = tf(num, den);

end