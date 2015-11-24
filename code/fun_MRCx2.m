%% MRC Decoder for 1x2 MIMO
%
% ECE 6604: 4G MIMO Research Project
% Klaus Okkelberg and Abhishek Obla Hema

function y = fun_MRCx2(x,chan)

N = size(x,1);
y = zeros(N,1);

for idx = 1:N
    y(idx) = chan(idx,:).'\x(idx,:).';
end