function [rise, fall, area, vout, vtop, vbot] =  plotEyeDiagram(vin, Nsym)
vin = vin - mean(vin);
K = floor(length(vin)/Nsym)-2;
vout = nan(K, 2*Nsym+1);
for k = 1:K
    vout(k, :) = vin((k-1)*Nsym+1:(k+1)*Nsym+1);
end
[~, ind] = max(min(abs(vout)));
shift = Nsym + 1 - ind;

vout = nan(K-1, 2*Nsym+1);
for k = 1:K-1
    vout(k, :) = vin(k*Nsym+1-shift:(k+2)*Nsym+1-shift);
end

% find rise and fall times
first_rise = 0; first_rise_count = 0;
first_fall = 0; first_fall_count = 0;
second_rise = 0; second_rise_count = 0;
second_fall = 0; second_fall_count = 0;
t = 1:Nsym+1;
first_rise_min = ones(1,length(t))*inf;
second_fall_min = ones(1,length(t))*inf;
first_fall_max = -ones(1,length(t))*inf;
second_rise_max = -ones(1,length(t))*inf;

for k = 1:K-1
    first = vout(k, 1:Nsym+1);
    first_cross = interp1(first, t, 0);
    if (~isnan(first_cross))
        n_low = floor(first_cross);
        m = diff(first(n_low:n_low+1))/12.5e-12;
        if (m > 0)
            first_rise = first_rise + m;
            first_rise_count = first_rise_count + 1;
            first_rise_min = min([first; first_rise_min]);
        else
            first_fall = first_fall + m;
            first_fall_count = first_fall_count + 1;
            first_fall_max = max([first; first_fall_max]);
        end
    end
    second = vout(k, Nsym+1:2*Nsym+1);
    second_cross = interp1(second, t, 0);
    if (~isnan(second_cross))
        n_low = floor(second_cross);
        m = diff(second(n_low:n_low+1))/12.5e-12;
        if (m > 0)
            second_rise = second_rise + m;
            second_rise_count = second_rise_count + 1;
            second_rise_max = max([second; second_rise_max]);
        else
            second_fall = second_fall + m;
            second_fall_count = second_fall_count + 1;
            second_fall_min = min([second; second_fall_min]);
        end
    end
end
vtop_mid = min([first_rise_min(end), second_fall_min(1)]);
vbot_mid = max([first_fall_max(end), second_rise_max(1)]);
vtop = [first_rise_min(1:end-1), vtop_mid, second_fall_min(2:end)];
vbot = [first_fall_max(1:end-1), vbot_mid, second_rise_max(2:end)];

first_rise = first_rise/first_rise_count;
first_fall = first_fall/first_fall_count;
second_rise = second_rise/second_rise_count;
second_fall = second_fall/second_fall_count;

% calculate outputs
rise = (first_rise+second_rise)/2;
fall = (first_fall+second_fall)/2;
vdiff = vtop - vbot;
area = sum(vdiff(vdiff>0));

% plot eye
plot([-Nsym:Nsym]*12.5, vout, '-ok'); hold all;
plot([-Nsym:Nsym]*12.5, vtop, '-b', 'linewidth', 4); hold all;
plot([-Nsym:Nsym]*12.5, vbot, '-b', 'linewidth', 4); hold all;
plot([-Nsym/2-1,-Nsym/2+1]*12.5, [-12.5,12.5]*1e-12*first_rise, '-r', 'linewidth', 2); hold all;
plot([-Nsym/2-1,-Nsym/2+1]*12.5, [-12.5,12.5]*1e-12*first_fall, '-r', 'linewidth', 2); hold all;
plot([Nsym/2-1,Nsym/2+1]*12.5, [-12.5,12.5]*1e-12*second_rise, '-r', 'linewidth', 2); hold all;
plot([Nsym/2-1,Nsym/2+1]*12.5, [-12.5,12.5]*1e-12*second_fall, '-r', 'linewidth', 2); hold all;
xlabel('Time [ps]')
ylabel('Voltage [V]')
title(sprintf('rise=%1.2fmV/ps, fall=%1.2fmV/ps, area=%1.2fmV*ps', rise*1e-9, fall*1e-9, area*1e3));
end