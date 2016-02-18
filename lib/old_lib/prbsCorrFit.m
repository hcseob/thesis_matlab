function x_bits = prbsCorrFit(x_bits_in)
if size(x_bits_in,1) > size(x_bits_in,2)
    x_bits_in = transpose(x_bits_in);
end
load('prbs.mat');
prbs1 = prbs1(1:127);
%% odd values
x_bits_odd = x_bits_in(1:2:2*length(prbs1));
maxCorr = 0; maxInd = 0;
for k = 1:length(prbs1)
    currentPRBS = circshift(prbs1,[0 k]);
    currentCorr = xcorr(x_bits_odd,currentPRBS,0);
    if abs(currentCorr) > abs(maxCorr)
        maxCorr = currentCorr;
        bestPRBS = currentPRBS;
    end
end
if maxCorr < 0
    bestPRBS = ~bestPRBS;
end
if ~isequal(bestPRBS,x_bits_odd)
    warning(strcat('did not find a perfect match with prbs1: matched ',num2str(sum(bestPRBS.*x_bits_odd))));
end
x_bits_odd_all = x_bits_in(1:2:end);
n = floor(length(x_bits_odd_all)/length(bestPRBS));
x_bits_odd_actual = repmat(bestPRBS,1,n);
p = length(x_bits_odd_all) - length(x_bits_odd_actual);
x_bits_odd_actual = [x_bits_odd_actual,prbs1(1:p)];

%% even values
x_bits_even = x_bits_in(2:2:2*length(prbs1));
maxCorr = 0; maxInd = 0;
for k = 1:length(prbs1)
    currentPRBS = circshift(prbs1,[0 k]);
    currentCorr = xcorr(x_bits_even,currentPRBS, 0);
    if abs(currentCorr) > abs(maxCorr)
        maxCorr = currentCorr;
        bestPRBS = currentPRBS;
    end
end
if maxCorr < 0
    bestPRBS = ~bestPRBS;
end
if ~isequal(bestPRBS,x_bits_even)
    warning(strcat('did not find a perfect match with prbs1: matched ',num2str(sum(bestPRBS.*x_bits_odd))));
end
x_bits_even_all = x_bits_in(2:2:end);
n = floor(length(x_bits_even_all)/length(bestPRBS));
x_bits_even_actual = repmat(bestPRBS,1,n);
p = length(x_bits_even_all) - length(x_bits_even_actual);
x_bits_even_actual = [x_bits_even_actual,prbs1(1:p)];


x_bits = nan(1,length(x_bits_in));
x_bits(1:2:end) = x_bits_odd_actual;
x_bits(2:2:end) = x_bits_even_actual;
end
