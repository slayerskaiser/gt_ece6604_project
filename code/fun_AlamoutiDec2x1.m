%% Alamouti Decoder for 2x1 MIMO
%
% ECE 6604: 4G MIMO Research Project
% Klaus Okkelberg and Abhishek Obla Hema

function y = fun_AlamoutiDec2x1(x,chan)

N = size(x,1);
y = zeros(N,1);

x(2:2:end) = conj(x(2:2:end));
for idx = 1:2:N
    H = [chan(idx,:); [conj(chan(idx+1,2)) -conj(chan(idx+1,1))]];
    y(idx:idx+1) = H\x(idx:idx+1);
end