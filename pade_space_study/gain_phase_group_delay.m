function gain_phase_group_delay
run('~/thesis/matlab/thesis.m'); addpath('./lib');

tau = 25e-12;
cen = round(log10(1/tau/2/pi));
f = logspace(cen-2, cen+1, 100);
w = 2*pi*f;
w_gd = (w(1:end-1)+w(2:end))/2;

gid = ones(size(f));
pid = -w*tau;
gdid = ones(length(f)-1, 1)*tau;

%% bessel delays
bs1 = bessel_sys(1, tau);
bs2 = bessel_sys(2, tau);
bs3 = bessel_sys(3, tau);

[g1, p1] = bode(bs1, w);
p1 = squeeze(p1)*pi/180;
gd1 = -diff(p1)./diff(w');

[g2, p2] = bode(bs2, w);
p2 = squeeze(p2)*pi/180;
gd2 = -diff(p2)./diff(w');

[g3, p3] = bode(bs3, w);
p3 = squeeze(p3)*pi/180;
gd3 = -diff(p3)./diff(w');

figure; 
semilogx(w_gd/2/pi/1e9, gd1/1e-12, '-k', 'linewidth', 3); hold all;
semilogx(w_gd/2/pi/1e9, gd2/1e-12, '--', 'linewidth', 3, 'color', stanford_red);
semilogx(w_gd/2/pi/1e9, gd3/1e-12, ':', 'linewidth', 3, 'color', new_blue);
semilogx(w_gd/2/pi/1e9, gdid/1e-12, '--k'); hold all;
ylim([0, 30]);
legend('N = 1', 'N = 2', 'N = 3', 'Ideal', 'location', 'southwest');
set(gca, 'fontsize', font_size);
xlabel('Frequency (GHz)', 'fontsize', font_size_label);
ylabel('Group Delay (ps)', 'fontsize', font_size_label)
save_fig('./figures/group_delay_bessel.eps');

figure; 
subplot(211);
semilogx(f/1e9, db(squeeze(g1)), '-k', 'linewidth', 3); hold all;
semilogx(f/1e9, db(squeeze(g2)), '--', 'linewidth', 3, 'color', stanford_red); hold all;
semilogx(f/1e9, db(squeeze(g3)), ':', 'linewidth', 3, 'color', new_blue); hold all;
semilogx(f/1e9, db(squeeze(gid)), '--k'); hold all;
ylim([-20, 10]);
% legend('N = 1', 'N = 2', 'N = 3', 'location', 'southwest');
set(gca, 'fontsize', font_size);
xlabel('Frequency (GHz)', 'fontsize', font_size_label);
ylabel('Magnitude (dB)', 'fontsize', font_size_label);
subplot(212);
semilogx(f/1e9, p1*180/pi, '-k', 'linewidth', 3); hold all;
semilogx(f/1e9, p2*180/pi, '--', 'linewidth', 3, 'color', stanford_red); hold all;
semilogx(f/1e9, p3*180/pi, ':', 'linewidth', 3, 'color', new_blue); hold all;
semilogx(f/1e9, pid*180/pi, '--k'); hold all;
ylim([-360, 100]);
legend('N = 1', 'N = 2', 'N = 3', 'Ideal', 'location', 'southwest');
set(gca, 'fontsize', font_size);
xlabel('Frequency (GHz)', 'fontsize', font_size_label);
ylabel('Phase (Degrees)', 'fontsize', font_size_label);
save_fig('./figures/gain_phase_bessel.eps');


%% pade delays
bs1 = pade_sys(1, tau);
bs2 = pade_sys(2, tau);
bs3 = pade_sys(3, tau);

[g1, p1] = bode(bs1, w);
p1 = squeeze(p1)*pi/180;
gd1 = -diff(p1)./diff(w');

[g2, p2] = bode(bs2, w);
p2 = squeeze(p2)*pi/180;
gd2 = -diff(p2)./diff(w');

[g3, p3] = bode(bs3, w);
p3 = squeeze(p3)*pi/180;
gd3 = -diff(p3)./diff(w');

figure; 
semilogx(w_gd/2/pi/1e9, gd1/1e-12, '-k', 'linewidth', 3); hold all;
semilogx(w_gd/2/pi/1e9, gd2/1e-12, '--', 'linewidth', 3, 'color', stanford_red);
semilogx(w_gd/2/pi/1e9, gd3/1e-12, ':', 'linewidth', 3, 'color', new_blue);
semilogx(w_gd/2/pi/1e9, gdid/1e-12, '--k'); hold all;
ylim([0, 30]);
set(gca, 'fontsize', font_size);
legend('N = 1', 'N = 2', 'N = 3', 'Ideal', 'location', 'southwest');
xlabel('Frequency (GHz)', 'fontsize', font_size_label);
ylabel('Group Delay (ps)', 'fontsize', font_size_label)
save_fig('./figures/group_delay_pade.eps');

figure; 
subplot(211);
semilogx(f/1e9, db(squeeze(g1)), '-k', 'linewidth', 3); hold all;
semilogx(f/1e9, db(squeeze(g2)), '--', 'linewidth', 3, 'color', stanford_red); hold all;
semilogx(f/1e9, db(squeeze(g3)), ':', 'linewidth', 3, 'color', new_blue); hold all;
semilogx(f/1e9, db(squeeze(gid)), '--k'); hold all;
ylim([-20, 10]);
% legend('N = 1', 'N = 2', 'N = 3', 'location', 'southwest');
set(gca, 'fontsize', font_size);
xlabel('Frequency (GHz)', 'fontsize', font_size_label);
ylabel('Magnitude (dB)', 'fontsize', font_size_label);
subplot(212);
semilogx(f/1e9, p1*180/pi-360, '-k', 'linewidth', 3); hold all;
semilogx(f/1e9, p2*180/pi-360, '--', 'linewidth', 3, 'color', stanford_red); hold all;
semilogx(f/1e9, p3*180/pi-720, ':', 'linewidth', 3, 'color', new_blue); hold all;
semilogx(f/1e9, pid*180/pi, '--k'); hold all;
legend('N = 1', 'N = 2', 'N = 3', 'Ideal', 'location', 'southwest');
ylim([-360, 100]);
set(gca, 'fontsize', font_size);
xlabel('Frequency (GHz)', 'fontsize', font_size_label);
ylabel('Phase (Degrees)', 'fontsize', font_size_label);
save_fig('./figures/gain_phase_pade.eps');

%% LC approximation
load_from_cadence = false;
if load_from_cadence
    addpath('/cad/cadence/MMSIM10.11.128.lnx86/tools.lnx86/spectre/matlab/64bit');
    data = cds_srr('/home/rboesch/simulation/delay_LCLC/spectre/schematic/psf', 'ac-ac', 'VOLC1');
    g1 = abs(data.V);
    p1 = -unwrap(angle(data.V));
    flc = data.freq;
    wlc = 2*pi*flc;
    wlc_gd = (wlc(1:end-1) + wlc(2:end))/2;
    gd1 = -diff(p1)./diff(wlc);

    data = cds_srr('/home/rboesch/simulation/delay_LCLC/spectre/schematic/psf', 'ac-ac', 'VOLC2');
    g2 = abs(data.V);
    p2 = -unwrap(angle(data.V));
    gd2 = -diff(p2)./diff(wlc);

    data = cds_srr('/home/rboesch/simulation/delay_LCLC/spectre/schematic/psf', 'ac-ac', 'VOLC3');
    g3 = abs(data.V);
    p3 = -unwrap(angle(data.V));
    gd3 = -diff(p3)./diff(wlc);
    save('gain_phase_group_delay_lc.mat');
else
    load('gain_phase_group_delay_lc.mat');
end

figure; 
semilogx(wlc_gd/2/pi/1e9, gd1/1e-12, '-k', 'linewidth', 3); hold all;
semilogx(wlc_gd/2/pi/1e9, gd2/1e-12, '--', 'linewidth', 3, 'color', stanford_red);
semilogx(wlc_gd/2/pi/1e9, gd3/1e-12, ':', 'linewidth', 3, 'color', new_blue);
semilogx(w_gd/2/pi/1e9, gdid/1e-12, '--k'); hold all;
ylim([0, 50]);
legend('N = 1', 'N = 2', 'N = 3', 'Ideal', 'location', 'southwest');
set(gca, 'fontsize', font_size);
xlabel('Frequency (GHz)', 'fontsize', font_size_label);
ylabel('Group Delay (ps)', 'fontsize', font_size_label);
save_fig('./figures/group_delay_lc.eps');

figure; 
subplot(211);
semilogx(flc/1e9, db(squeeze(2*g1)), '-k', 'linewidth', 3); hold all;
semilogx(flc/1e9, db(squeeze(2*g2)), '--', 'linewidth', 3, 'color', stanford_red); hold all;
semilogx(flc/1e9, db(squeeze(2*g3)), ':', 'linewidth', 3, 'color', new_blue); hold all;
semilogx(f/1e9, db(squeeze(gid)), '--k'); hold all;
ylim([-20, 10]);
% legend('N = 1', 'N = 2', 'N = 3', 'location', 'southwest');
set(gca, 'fontsize', font_size);
xlabel('Frequency (GHz)', 'fontsize', font_size_label);
ylabel('Magnitude (dB)', 'fontsize', font_size_label);
subplot(212);
semilogx(flc/1e9, p1*180/pi, '-k', 'linewidth', 3); hold all;
semilogx(flc/1e9, p2*180/pi, '--', 'linewidth', 3, 'color', stanford_red); hold all;
semilogx(flc/1e9, p3*180/pi, ':', 'linewidth', 3, 'color', new_blue); hold all;
semilogx(f/1e9, pid*180/pi, '--k'); hold all;
ylim([-360, 100]);
legend('N = 1', 'N = 2', 'N = 3', 'Ideal', 'location', 'southwest');
set(gca, 'fontsize', font_size);
xlabel('Frequency (GHz)', 'fontsize', font_size_label);
ylabel('Phase (Degrees)', 'fontsize', font_size_label)
save_fig('./figures/gain_phase_lc.eps');

end
