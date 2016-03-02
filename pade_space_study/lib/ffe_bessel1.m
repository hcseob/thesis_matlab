function [pout, ps] = ffe_bessel1(pulse, t, delay, BW, coeffs)

rc = tf([1], [1/2/pi/BW, 1]);
delay_cell = bessel_sys(1, delay);
num_taps = length(coeffs);
for j = 1:num_taps
    ps(:, j) = lsim((delay_cell*rc)^(j-1)*rc^2, pulse, t);
end

pout = ps*coeffs;

end