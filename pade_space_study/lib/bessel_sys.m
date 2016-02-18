function  sys = bessel_sys(order, delay)
d = delay;
if order == 1
    num = [1];
    den = [d, 1];
elseif order == 2
    num = [1];    
    den = [d^2/3, d, 1];
else
    num = [1];   
    den = [d^3/15, d^2*2/5, d, 1];   
end

sys = tf(num, den);

end