clear all; close all; addpath('~/MATLAB/lib');
%%
syms b0 b1 b2 b3 b4;
syms st a;
D1 = (1-a*st)/(1+st);
TF0=expand((1+st)^4);
[c0,ord]=coeffscorrected(TF0,st);
TF1=expand((1+st)^3*(1-a*st));
[c1,ord]=coeffscorrected(TF1,st);
TF2=expand((1+st)^2*(1-a*st)^2);
[c2,ord]=coeffscorrected(TF2,st);
TF3=expand((1+st)^1*(1-a*st)^3);
[c3,ord]=coeffscorrected(TF3,st);
TF4=expand((1-a*st)^4);
[c4,ord]=coeffscorrected(TF4,st);

A = transpose([c4;c3;c2;c1;c0]);
save('A.mat', 'A');
Aeval = subs(A,a,0.5);
B = subs(A,a,1);
x=[1;2;3;4;5];
b = double(Aeval^-1*B)*[1;2;3;4;5];
%%
f = logspace(-3,0,100);
s = i*2*pi*f;
tau = 1;
alpha = 0.5;
Hs0 = (1-s*tau/2)./(1+s*tau/2);
Hs1 = (1-alpha*s*tau/2)./(1+s*tau/2);

TF0 = x(5)+x(4)*Hs0+x(3)*Hs0.^2+x(2)*Hs0.^3+x(1)*Hs0.^4;
TF1 = b(5)+b(4)*Hs1+b(3)*Hs1.^2+b(2)*Hs1.^3+b(1)*Hs1.^4;

figure;
semilogx(f,db(TF0)); hold all;
semilogx(f,db(TF1),'x'); hold all;

%%
alphasweep = [0.01:0.01:1];
for k = 1:length(alphasweep)
    Aeval = subs(A,a,alphasweep(k));
    M = double(Aeval^-1*B);
    S = transpose(M)*M;
    [V,D] = eig(S);
    spectralNorm(k) = sqrt(max(real(diag(D))));
end
figure; hold all;
plot(alphasweep, spectralNorm, '-k', 'linewidth', 2);
plot([0, 0.33], spectralNorm(33)*[1, 1], '--k')
plot([0.33, 0.33], [spectralNorm(33), 0], '--k')
grid on;
xlabel('\alpha')
ylabel('C_{\alpha}^{-1}C_1 Spectral Norm')
xlim([0.1, 1])
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 18);
print('-dpng','./figures/SpectralNormPlot.png');



%%
Aeval = subs(A,a,0);
M = double(Aeval^-1*B);
S = transpose(M)*M;
[V, D]= eig(S);
sN = sqrt(max(real(diag(D))));
v5 = V(:, 5);


x = v5;
b = M*v5;
Hs0 = (1-s*tau/2)./(1+s*tau/2);
Hs1 = 1./(1+s*tau/2);

TF0 = x(5)+x(4)*Hs0+x(3)*Hs0.^2+x(2)*Hs0.^3+x(1)*Hs0.^4;
TF1 = b(5)+b(4)*Hs1+b(3)*Hs1.^2+b(2)*Hs1.^3+b(1)*Hs1.^4;
figure;
subplot(211);
semilogx(f,db(TF0)); hold all;
semilogx(f,db(TF1),'x'); hold all;

subplot(212);
semilogx(f,unwrap(angle(TF0))); hold all;
semilogx(f,unwrap(angle(TF1)),'x'); hold all;

figure;
subplot(211);
semilogx(f,db(Hs0)); hold all;
semilogx(f,db(Hs1),'x'); hold all;

subplot(212);
semilogx(f,unwrap(angle(Hs0))); hold all;
semilogx(f,unwrap(angle(Hs1)),'x'); hold all;


