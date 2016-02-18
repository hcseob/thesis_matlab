function delay = findDelay(x,t,T)

maxNorm = 0;
for d = 0:1:9
    currentDelay = d * T/10;
    currentNorm = norm(interp1(t,x,[t(1) + currentDelay:T:t(end)]));
    if currentNorm > maxNorm
        maxNorm = currentNorm;
        delay = currentDelay;
    end
end