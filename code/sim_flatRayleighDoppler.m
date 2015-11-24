%% Comparison of MIMO methods for flat Rayleigh fading channel with Doppler shift
%
% ECE 6604: 4G MIMO Research Project
% Klaus Okkelberg and Abhishek Obla Hema

function ber = sim_flatRayleighDoppler(EbNo,numPackets,Mmod,hMod,hDemod,fm_norm)

charCount = 0;
wb = 0;
fprintf('Running... ')
call_wb = @(x,count) fprintf([repmat('\b',1,count) ...
    '%0.1f%%, t=%f'], ...
    round(x*1000)/10, toc);
wb_step = numPackets/100;

% parameters
frameLen = 120;
blockLen = 4;
N = 8; % max Tx
M = 2; % max Rx
% preallocate channel
minrate = 1/2;
H = zeros(frameLen/minrate,N,M);

% Set the global random stream for repeatability
s = RandStream.create('mt19937ar', 'seed',55408);
prevStream = RandStream.setGlobalStream(s);

%% Modulation
hAWGN1Rx = comm.AWGNChannel('NoiseMethod','Signal to noise ratio (Eb/No)', ...
    'SignalPower',1,'BitsPerSymbol',Mmod);
hAWGN2Rx = clone(hAWGN1Rx);
hAWGN2Rx_r34 = clone(hAWGN1Rx);
hAWGN2Rx_r12 = clone(hAWGN1Rx);

hError11 = comm.ErrorRate;
hError21 = comm.ErrorRate;
hError12 = comm.ErrorRate;
hError22 = comm.ErrorRate;
hError42 = comm.ErrorRate;
hError42q = comm.ErrorRate;
hError42_12 = comm.ErrorRate;
hError82 = comm.ErrorRate;
ber11 = zeros(3,length(EbNo));
ber21 = zeros(3,length(EbNo));
ber12 = zeros(3,length(EbNo));
ber22 = zeros(3,length(EbNo));
ber42 = zeros(3,length(EbNo));
ber42q = zeros(3,length(EbNo));
ber42_12 = zeros(3,length(EbNo));
ber82 = zeros(3,length(EbNo));

%% Transmission
% Assume Rayleigh fading, no shadowing, no Doppler

for idx = 1:length(EbNo)
    reset(hError11);
    reset(hError21);
    reset(hError12);
    reset(hError22);
    reset(hError42);
    reset(hError42q);
    reset(hError42_12);
    reset(hError82);
    hAWGN1Rx.EbNo = EbNo(idx);
    hAWGN2Rx.EbNo = EbNo(idx);
    hAWGN2Rx_r12.EbNo = EbNo(idx);
    hAWGN2Rx_r34.EbNo = EbNo(idx);
    
    for packetIdx = 1:numPackets
        data = randi([0 1],frameLen*log2(Mmod),1);
        modData = step(hMod, data);
        
        %%% Flat Rayleigh fading with Doppler shift (statistical model)
        alpha = -pi + 2*pi*randn(1,2*N,1);
        beta = -pi + 2*pi*randn(1,2*N,2*N);
        phi = -pi + 2*pi*randn(1,2*N,2*N);
        theta = bsxfun(@plus, pi/(4*N)*reshape(1:2*N,[1 1 2*N]), ...
            pi/(32*N^2)*(0:2*N-1) + (alpha-pi)/(8*N));
        tmp = bsxfun(@plus, phi, bsxfun(@times, cos(theta), ...
            2*pi*fm_norm*(0:frameLen/minrate/blockLen-1).'));
        gI = sum( bsxfun(@times, cos(beta), cos(tmp)), 3);
        gQ = sum( bsxfun(@times, sin(beta), sin(tmp)), 3);
        H(1:blockLen:end,:,:) = reshape((gI + 1j*gQ)/sqrt(2), ...
            frameLen/minrate/blockLen,N,M);
        for k = 2:blockLen
            H(k:blockLen:end,:,:) = H(1:blockLen:end,:,:);
        end
                
        %%% SISO
        H11 = H(1:frameLen,1,1);
        chanOut11 = H11 .* modData;
        rxSig11 = step(hAWGN1Rx, chanOut11);
        demod11 = step(hDemod, rxSig11./H11);
        
        %%% MIMO: 1x2 MRC
        H12 = H(1:frameLen,1,:);
        chanOut12 = squeeze(sum(H12 .* repmat(modData, [1 1 2]), 2));
        rxSig12 = step(hAWGN2Rx, chanOut12);
        decData12 = fun_MRCx2(rxSig12, H12);
        demod12 = step(hDemod, decData12);
        
        %%% MIMO: 2x1 Alamouti
        encData = fun_AlamoutiEnc(modData);
        H21 = H(1:frameLen,1:2,1)/sqrt(2);
        chanOut21 = sum(H21.*encData,2);
        rxSig21 = step(hAWGN1Rx, chanOut21);
        decData21 = fun_AlamoutiDec2x1(rxSig21, H21);
        demod21 = step(hDemod, decData21);
        
        %%% MIMO: 2x2 Alamouti
        H22 = H(1:frameLen,1:2,:)/sqrt(2);
        chanOut22 = squeeze(sum(H22 .* repmat(encData, [1 1 2]), 2));
        rxSig22 = step(hAWGN2Rx, chanOut22);
        decData22 = fun_AlamoutiDec2x2(rxSig22, H22);
        demod22 = step(hDemod, decData22);
        
        %%% MIMO: 4x2 OSTBC, rate=1/2
        H42_12 = H(1:2*frameLen,1:4,:)/sqrt(4);
        encData = fun_OSTBC2Enc4x(modData);
        chanOut42_12 = squeeze(sum(H42_12 .* repmat(encData, [1 1 2]), 2));
        rxSig42_12 = step(hAWGN2Rx_r12, chanOut42_12);
        decData42_12 = fun_OSTBC2Dec4x2(rxSig42_12, H42_12);
        demod42_12 = step(hDemod, decData42_12);
        
        %%% MIMO: 4x2 OSTBC, rate=3/4
        H42 = H(1:4/3*frameLen,1:4,:)/sqrt(4);
        encData = fun_OSTBCEnc4x(modData);
        chanOut42 = squeeze(sum(H42 .* repmat(encData, [1 1 2]), 2));
        rxSig42 = step(hAWGN2Rx_r34, chanOut42);
        decData42 = fun_OSTBCDec4x2(rxSig42, H42);
        demod42 = step(hDemod, decData42);
        
        %%% MIMO: 4x2 QOSTBC, rate=1
        H42q = H(1:frameLen,1:4,:)/sqrt(4);
        encData = fun_QOSTBCEnc4x(modData);
        chanOut42q = squeeze(sum(H42q .* repmat(encData, [1 1 2]), 2));
        rxSig42q = step(hAWGN2Rx, chanOut42q);
        decData42q = fun_QOSTBCDec4x2(rxSig42q, H42q);
        demod42q = step(hDemod, decData42q);
        
        %%% MIMO: 8x2 OSTBC, rate=1/2
        H82 = H(1:2*frameLen,1:8,:)/sqrt(8);
        encData = fun_OSTBC2Enc8x(modData);
        chanOut82 = squeeze(sum(H82 .* repmat(encData, [1 1 2]), 2));
        rxSig82 = step(hAWGN2Rx_r12, chanOut82);
        decData82 = fun_OSTBC2Dec8x2(rxSig82, H82);
        demod82 = step(hDemod, decData82);
        
        % get BER
        ber11(:,idx) = step(hError11, data, demod11);
        ber21(:,idx) = step(hError21, data, demod21);
        ber12(:,idx) = step(hError12, data, demod12);
        ber22(:,idx) = step(hError22, data, demod22);
        ber42(:,idx) = step(hError42, data, demod42);
        ber42q(:,idx) = step(hError42q, data, demod42q);
        ber42_12(:,idx) = step(hError42_12, data, demod42_12);
        ber82(:,idx) = step(hError82, data, demod82);
        
        % waitbar
        if mod(packetIdx,wb_step) == 0
            wb = wb + wb_step/length(EbNo)/numPackets;
            charCount = call_wb(wb,charCount) - charCount;
        end
    end
    % waitbar
    wb = idx/length(EbNo);
end

% Restore default stream
RandStream.setGlobalStream(prevStream);

%% Collect results
ber = {ber11;ber21;ber12;ber22;ber42_12;ber42;ber42q;ber82};
ber = cellfun(@(x) x(1,:), ber, 'uni', 0);