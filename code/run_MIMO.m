%% Comparison of MIMO and SISO with different equalization methods
%
% ECE 6604: 4G MIMO Research Project
% Klaus Okkelberg and Abhishek Obla Hema

clear
close all
tic

% simulation parameters
numPackets = 1e5;
EbNo = 0:2:30;
v = 5; % m/s
Ts = 1/15e3; % symbol rate is 15 kHz to sub-carrier spacing for LTE
fc = 1800e6; % carrier freq of 1800 MHz
fm_norm = v*fc/3e8*Ts; % normalized max. Doppler freq. (fm*Ts)

% modulation method
M = 64;
hMod = comm.RectangularQAMModulator(M, ...
    'NormalizationMethod', 'Average power', 'BitInput', true);
hDemod = comm.RectangularQAMDemodulator(M, ...
    'NormalizationMethod', 'Average power', 'BitOutput', true);
% hMod = comm.PSKModulator(M, 'PhaseOffset', 0, ...
%     'BitInput', true);
% hDemod = comm.PSKDemodulator(M, 'PhaseOffset', 0, ...
%     'BitOutput', true);

%% Run simulation

% ber = sim_flatRayleigh(EbNo,numPackets,M,hMod,hDemod);
ber = sim_flatRayleighDoppler(EbNo,numPackets,M,hMod,hDemod,fm_norm);

%% Clean-up

fprintf('\nTotal time = %f\n',toc)

ber_QAM64 = ber;
save ber_5 ber_QAM64 -append