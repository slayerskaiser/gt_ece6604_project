%% Alamouti Decoder for 2x2 MIMO
%
% ECE 6604: 4G MIMO Research Project
% Klaus Okkelberg and Abhishek Obla Hema

function y = fun_AlamoutiDec2x2(x,chan)

N = size(x,1);
y = zeros(N,1);

x(2:2:end,:) = conj(x(2:2:end,:));
for idx = 1:2:N
    H = [chan(idx,:,1); chan(idx,:,2); ...
        conj(chan(idx+1,2,1)) -conj(chan(idx+1,1,1)); ...
        conj(chan(idx+1,2,2)) -conj(chan(idx+1,1,2))];
    y(idx:idx+1) = H\reshape(x(idx:idx+1,:).',4,1);
end