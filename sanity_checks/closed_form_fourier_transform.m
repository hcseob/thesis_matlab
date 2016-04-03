clear all; close all;
addpath('./lib');
addpath('../pade_space_study/lib');
run('~/thesis/matlab/thesis.m');
load('../../data/channels/channels.mat');

fix_cadence_ac = @(H) abs(H).*exp(-1i*phase(H)*pi/180);

%% insertion loss
f = IL.f;
IL0 = fix_cadence_ac(IL.nel0);
IL1 = fix_cadence_ac(IL.nel1);
IL2 = fix_cadence_ac(IL.nel2);
IL3 = fix_cadence_ac(IL.nel3);

plot_ils = false;
if plot_ils
    figure; hold all;
    plot(f/1e9, db(IL0));
    plot(f/1e9, db(IL1));
    plot(f/1e9, db(IL2));
    plot(f/1e9, db(IL3));

    figure; hold all;
    plot(f/1e9, phase(IL0)*180/pi);
    plot(f/1e9, phase(IL1)*180/pi);
    plot(f/1e9, phase(IL2)*180/pi);
    plot(f/1e9, phase(IL3)*180/pi);
end
%% pulse responses
t = p_norm.t';
p0 = p_norm.nel0';
p1 = p_norm.nel1';
p2 = p_norm.nel2';
p3 = p_norm.nel3';

plot_pulses = false;
if plot_pulses
    figure; hold all;
    plot(p_norm.t, p0);
    plot(p_norm.t, p1);
    plot(p_norm.t, p2);
    plot(p_norm.t, p3);
end
%%
df = 100e6;
fi = (df:df:f(end))';
Ni = length(fi);
IL0i = interp1(f, IL0, fi);

[a, fs, IL0_fit_db] = il_fit(fi, IL0i);

%%
Xr0 = [real(IL0i); real(IL0i(end:-1:1))];
Xi0 = [imag(IL0i); -imag(IL0i(end:-1:1))];
X0 = Xr0 + 1i*Xi0;
fi_fft = (1:2*Ni)*df;

figure; hold all;
plot(fi_fft, db(X0));
plot(fi, db(IL0i));
plot(fi, -IL0_fit_db);

%%
% create the fit terms k3 and k2
k2 = (a(2)/sqrt(1e9))*log(10)/20/sqrt(2*pi);
k3 = (a(3)/1e9)*log(10)/20/(2*pi);
fk = (df:df:200e9)';

% create ILs parts from the terms above
il_k2 = exp(-k2*sqrt(2*pi*fk));
il_k3 = exp(-k3*2*pi*fk);
il_ks = il_k2.*il_k3;

% plot actual, fit, and fit terms
plot_fit_terms = false;
if plot_fit_terms
    figure; hold all;
    plot(fi_fft, db(X0));
    plot(fk, db(il_k3));
    plot(fk, db(il_k2));
    plot(fk, db(il_k2)+db(il_k3));
end

% create Xi3, Xr3, Xi2, Xr2
Xr2 = [il_k2; il_k2(end:-1:1)];
Xi2 = [il_k2; -il_k2(end:-1:1)];
X2 = Xr2 + 1i*Xi2;

Xr3 = [il_k3; il_k3(end:-1:1)];
Xi3 = [il_k3; -il_k3(end:-1:1)];
X3 = Xr3 + 1i*Xi3;

% create xe3, xo3, xe2, xo2
Nk = length(Xr2);
tk = (0:Nk-1)'/Nk/diff(fk(1:2));

xe2 = real(ifft(Xr2));
xe2 = circshift(xe2(:), Nk/2);
xe2 = xe2/max(xe2);

xo2 = real(ifft(1i*Xi2));
xo2 = circshift(xo2(:), Nk/2);
xo2 = xo2/max(xo2);

xe3 = real(ifft(Xr3));
xe3 = circshift(xe3(:), Nk/2);
xe3 = xe3/max(xe3);

xo3 = real(ifft(1i*Xi3));
xo3 = circshift(xo3(:), Nk/2);
xo3 = xo3/max(xo3);
% plot even cases on the plot below. also plot the actual pulse for
% comparison

% think about the next step. some way to combine to create the real pulse

%%
t0 = (0:2*Ni-1)/(2*Ni)/df;
x0 = real(ifft(X0));
x0 = circshift(x0(:), Ni);
x0 = x0/max(x0);

%%
[~, max_ind] = max(p0);
t_p0 = t(max_ind);

dtk = diff(tk(1:2));
shift = round(-(5e-9-t_p0)/dtk);
xe2s = circshift(xe2, shift);
xo2s = circshift(xo2, shift);
xe3s = circshift(xe3, shift);
xo3s = circshift(xo3, shift);

%%
S = 800;
X = [xe3s(1:800), xo3s(1:800), xe2s(1:800), xo2s(1:800)];
tn = tk(1:800);
figure; hold all;
plot(tn, X(:, 1), '-k');
plot(tn, X(:, 2), '-b');
plot(tn, X(:, 3), '-r');
plot(tn, X(:, 3), '-g');
plot(t, p0, '-k', 'linewidth', 2);
% xlim([4e-9, 6e-9])

