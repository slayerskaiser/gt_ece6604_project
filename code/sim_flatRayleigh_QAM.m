%% Comparison of MIMO methods for flat Rayleigh fading channel
%
% ECE 6604: 4G MIMO Research Project
% Klaus Okkelberg and Abhishek Obla Hema

function fitBER = sim_flatRayleigh_QAM(EbNo,numPackets,MQAM)

wb = 0;
call_wb = @(x) fprintf('Running... %d%%, t=%f\n', ...
    round(x*100), toc);

% parameters
frameLen = 120;
blockLen = 4;
N = 4; % max Tx
M = 2; % max Rx
% preallocate channel
rate = 3/4; % for 4x MIMO
H = zeros(frameLen/rate,N,M);

% Set the global random stream for repeatability
s = RandStream.create('mt19937ar', 'seed',55408);
prevStream = RandStream.setGlobalStream(s);

%% Modulation
hMod = comm.RectangularQAMModulator(MQAM, ...
    'NormalizationMethod', 'Average power', 'BitInput', true);
hDemod = comm.RectangularQAMDemodulator(MQAM, ...
    'NormalizationMethod', 'Average power', 'BitOutput', true);

hAWGN1Rx = comm.AWGNChannel('NoiseMethod','Signal to noise ratio (Eb/No)', ...
    'SignalPower',1,'BitsPerSymbol',MQAM);
hAWGN2Rx = clone(hAWGN1Rx);
hAWGN4Tx2Rx = clone(hAWGN1Rx);

hError11 = comm.ErrorRate;
hError21 = comm.ErrorRate;
hError22 = comm.ErrorRate;
hError42 = comm.ErrorRate;
ber11 = zeros(3,length(EbNo));
ber21 = zeros(3,length(EbNo));
ber22 = zeros(3,length(EbNo));
ber42 = zeros(3,length(EbNo));

%% Transmission
% Assume Rayleigh fading, no shadowing, no Doppler

for idx = 1:length(EbNo)
    reset(hError11);
    reset(hError21);
    reset(hError22);
    reset(hError42);
    
    for packetIdx = 1:numPackets
        data = randi([0 1],frameLen*log2(MQAM),1);
        modData = step(hMod, data);
        hAWGN1Rx.EbNo = EbNo(idx);
        hAWGN2Rx.EbNo = EbNo(idx);
        hAWGN4Tx2Rx.EbNo = EbNo(idx);
        
        %%% Flat Rayleigh fading
        H(1:blockLen:end,:,:) = (randn(frameLen/rate/blockLen,N,M) ...
            + 1j*randn(frameLen/rate/blockLen,N,M))/sqrt(2);
        for k = 2:blockLen
            H(k:blockLen:end,:,:) = H(1:blockLen:end,:,:);
        end
                
        %%% SISO
        H11 = H(1:frameLen,1,1);
        chanOut11 = H11 .* modData;
        rxSig11 = step(hAWGN1Rx, chanOut11);
        demod11 = step(hDemod, rxSig11./H11);
        
        %%% MIMO: 2x1
        encData = fun_AlamoutiEnc(modData);
        H21 = H(1:frameLen,1:2,1)/sqrt(2);
        chanOut21 = sum(H21.*encData,2);
        rxSig21 = step(hAWGN1Rx, chanOut21);
        decData21 = fun_AlamoutiDec2x1(rxSig21, H21);
        demod21 = step(hDemod, decData21);
        
        %%% MIMO: 2x2
        
        H22 = H(1:frameLen,1:2,:)/sqrt(2);
        chanOut22 = squeeze(sum(H22 .* repmat(encData, [1 1 2]), 2));
        rxSig22 = step(hAWGN2Rx, chanOut22);
        decData22 = fun_AlamoutiDec2x2(rxSig22, H22);
        demod22 = step(hDemod, decData22);
        
        %%% MIMO: 4x2
        H42 = H/sqrt(4);
        encData = fun_OSTBCEnc4x(modData);
        chanOut42 = squeeze(sum(H42 .* repmat(encData, [1 1 2]), 2));
        rxSig42 = step(hAWGN4Tx2Rx, chanOut42);
        decData42 = fun_OSTBCDec4x2(rxSig42, H42);
        demod42 = step(hDemod, decData42);
        
        % get BER
        ber11(:,idx) = step(hError11, data, demod11);
        ber21(:,idx) = step(hError21, data, demod21);
        ber22(:,idx) = step(hError22, data, demod22);
        ber42(:,idx) = step(hError42, data, demod42);
        
        if mod(packetIdx,1000) == 0
            wb = wb + 1000/length(EbNo)/numPackets;
            call_wb(wb);
        end
    end
    % waitbar
    wb = idx/length(EbNo);
end

% Restore default stream
RandStream.setGlobalStream(prevStream);

%% Collect results
fitBER11 = berfit(EbNo, ber11(1,:)+eps);
fitBER21 = berfit(EbNo, ber21(1,:)+eps);
fitBER22 = berfit(EbNo, ber22(1,:)+eps);
fitBER42 = berfit(EbNo, ber42(1,:)+eps);

fitBER = {fitBER11; fitBER21; fitBER22; fitBER42};