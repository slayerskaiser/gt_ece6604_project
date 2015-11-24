%% Alamouti Encoder
%
% ECE 6604: 4G MIMO Research Project
% Klaus Okkelberg and Abhishek Obla Hema

function y = fun_AlamoutiEnc(x)

N = length(x);
y = zeros(N,2);

y(1:2:end,1) = x(1:2:end);
y(2:2:end,1) = -conj(x(2:2:end));
y(1:2:end,2) = x(2:2:end);
y(2:2:end,2) = conj(x(1:2:end));