clear all; close all;
f = logspace(-3,0,30);
s = i*2*pi*f;
tau = 1;
alpha = 0.333;
Hs0 = (1-s*tau/2)./(1+s*tau/2);
Hs1 = (1-alpha*s*tau/2)./(1+s*tau/2);

B = [alpha^2,-alpha,1;-2*alpha,1-alpha,2;1,1,1];
A = [1,-1,1;-2,0,2;1,1,1];

a=[1;2;3];
b=B^-1*A*a;
b = [9/4; 3/2; 9/4]

TF0 = a(3)+a(2)*Hs0+a(1)*Hs0.^2;
TF1 = b(3)+b(2)*Hs1+b(1)*Hs1.^2;

figure;
subplot(2, 1, 1);
semilogx(f, db(TF0), '-k', 'linewidth', 2); hold all;
semilogx(f, db(TF1), 'xk', 'linewidth', 2, 'markersize', 10); hold all;
xlabel('Normalized Frequency [1/\tau]');
ylabel('Magnitude [dB]');
legend('|H_1(s)|', '|H_{1/3}(s)|', 'location', 'SouthWest');
grid on;
subplot(2, 1, 2)
semilogx(f, unwrap(phase(TF0))*180/pi, '-k', 'linewidth', 2); hold all;
semilogx(f, unwrap(phase(TF1))*180/pi, 'xk', 'linewidth', 2, 'markersize', 10); hold all;
xlabel('Normalized Frequency [1/\tau]');
ylabel('Phase [Degrees]');
ylim([-60, 10]);
legend('\angle H_1(s)', '\angle H_{1/3}(s)', 'location', 'SouthWest');
grid on;
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 18);
print('-dpng', './figures/example.png');
