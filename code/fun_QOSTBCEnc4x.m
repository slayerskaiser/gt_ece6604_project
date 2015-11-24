%% QOSTBC Encoder for 4 Tx
%
% ECE 6604: 4G MIMO Research Project
% Klaus Okkelberg and Abhishek Obla Hema

function y = fun_QOSTBCEnc4x(x)
% Lt = 4, R = 1 code
% C = [ s1   s2   s3   s4;
%      -s2*  s1* -s4*  s3*;
%       s3   s4   s1   s2;
%      -s4*  s3* -s2*  s1*]

N = length(x);
y = zeros(N,4);
x1 = x(1:4:end);
x2 = x(2:4:end);
x3 = x(3:4:end);
x4 = x(4:4:end);

y(1:4:end,:) = [x1 x2 x3 x4];
y(2:4:end,:) = conj([-x2 x1 -x4 x3]);
y(3:4:end,:) = [x3 x4 x1 x2];
y(4:4:end,:) = conj([-x4 x3 -x2 x1]);