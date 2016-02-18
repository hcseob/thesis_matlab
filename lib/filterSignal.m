function y = filterSignal(x,t,fbw,ford)
fsamp = 1/diff(t(1:2));
[num,den] = besself(ford,fbw);
[numd,dend] = bilinear(num,den,fsamp);
y=filter(numd,dend,x);

