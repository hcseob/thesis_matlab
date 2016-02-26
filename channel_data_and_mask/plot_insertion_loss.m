clear all; close all; run('~/thesis/matlab/thesis.m'); addpath('./lib');

path = '../../data/channels/TEC_STRADA_WHISPER/TEC_Whisper29p8in_Nelco6/';
fname = 'TEC_Whisper29p8in_Nelco6_THRU_C8C9.s4p';
nel29 = extract_s4p([path, fname]);
path = '../../data/channels/TEC_STRADA_WHISPER/TEC_Whisper29p8in_Meg6/';
fname = 'TEC_Whisper29p8in_Meg6_THRU_C8C9.s4p';
meg29 = extract_s4p([path, fname]);
path = '../../data/channels/TEC_STRADA_WHISPER/TEC_Whisper42p8in_Nelco6/';
fname = 'TEC_Whisper42p8in_Nelco6_THRU_C8C9.s4p';
nel42 = extract_s4p([path, fname]);
path = '../../data/channels/TEC_STRADA_WHISPER/TEC_Whisper42p8in_Meg6/';
fname = 'TEC_Whisper42p8in_Meg6_THRU_C8C9.s4p';
meg42 = extract_s4p([path, fname]);


f_GHz = logspace(-1, log10(30), 1000); 
IL_db = 1.083+2.543*sqrt(f_GHz)+0.761*f_GHz;
IL = 10.^(-IL_db/20);
f = 1e9*f_GHz;

%%
figure;
plot(nel29.f/1e9, db(squeeze(nel29.magS(2, 1, :))), '-k'); hold all;
plot(nel29.f/1e9, db(squeeze(nel29.magS(4, 3, :))), '-k'); hold all;

plot(meg29.f/1e9, db(squeeze(meg29.magS(2, 1, :))), '-b'); hold all;
plot(meg29.f/1e9, db(squeeze(meg29.magS(4, 3, :))), '-b'); hold all;

plot(nel42.f/1e9, db(squeeze(nel42.magS(2, 1, :))), '-r'); hold all;
plot(nel42.f/1e9, db(squeeze(nel42.magS(4, 3, :))), '-r'); hold all;

plot(meg42.f/1e9, db(squeeze(meg42.magS(2, 1, :))), '-g'); hold all;
plot(meg42.f/1e9, db(squeeze(meg42.magS(4, 3, :))), '-g'); hold all;

plot(f/1e9, db(IL), '-k');
xlabel('Frequency [GHz]');
xlim([0, 40])
ylim([-80, 0])
