function [vodr, vodrs, vod, vods] = clock_recovery(x)
[vod, vods, ~] = mean_cycles(x);

J = size(vods, 2);
K = size(vods, 1);

for j = 1:J
    for k = 1:K-1
        v0 = vods(k, j);
        v1 = vods(k+1, j);
        if (v0 < 0) && (v1 > 0)
            kc(j) = k + (v0/(v0-v1));
            break;
        end
    end
end

inds = [1:length(kc)];
c = polyfit(inds, kc, 1);
slope = c(1);

% figure; hold all;
% plot(inds, kc, '-k');
% plot(inds, c(2)+c(1)*inds, '-b', 'linewidth', 2);

inds = (1:1+slope/K:length(x));
if length(inds) > length(x)
    inds = inds(1:length(x));
end
x_recovered = interp1(1:length(x), x, inds);

[vodr, vodrs, ~] = mean_cycles(x_recovered);
end
