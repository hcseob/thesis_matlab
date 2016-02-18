function x_bits = dataToBits(t,x,period,prbsFit)
delay = findDelay(x,t,period);
os = (max(x) + min(x))/2;
t_bits = [t(1) + delay:period:t(end)+delay];
x_diff = diff(interp1(t,x,t_bits,'linear','extrap'));

[counts,centers] = hist(abs(x_diff),20);
[~,minInd] = min(counts(1:floor(length(counts)/2)));
threshold = centers(minInd);

x_bits = x_diff;
x_bits(abs(x_bits) < threshold) = 0;
x_bits(x_bits < 0) = -1;
x_bits(x_bits > 0) = 1;
firstBit = (interp1(t,x,delay) > os) * 2 - 1;
for k = 1:length(x_bits)
    if (x_bits(k) == 0) && (k ~= 1)
        x_bits(k) = x_bits(k-1);
    elseif (x_bits(k) == 0) && (k == 1)
        x_bits(k) = firstBit;
    end
end
x_bits = [firstBit,x_bits];
x_bits = x_bits > 0;

if prbsFit
    x_bits = prbsCorrFit(x_bits); 
end
end