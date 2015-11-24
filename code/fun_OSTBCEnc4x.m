%% OSTBC Encoder for 4 Tx
%
% ECE 6604: 4G MIMO Research Project
% Klaus Okkelberg and Abhishek Obla Hema

function y = fun_OSTBCEnc4x(x)
% Lt = 4, R = 3/4 code
% C = [ s1   s2   s3    0;
%      -s2*  s1*   0   s3;
%       s3*   0  -s1*  s2;
%        0   s3* -s2* -s1]

N = length(x);
y = zeros(4/3*N,4);
x1 = x(1:3:end);
x2 = x(2:3:end);
x3 = x(3:3:end);

y(1:4:end,1) = x1;
y(1:4:end,2) = x2;
y(1:4:end,3) = x3;

y(2:4:end,1) = -conj(x2);
y(2:4:end,2) = conj(x1);
y(2:4:end,4) = x3;

y(3:4:end,1) = conj(x3);
y(3:4:end,3) = -conj(x1);
y(3:4:end,4) = x2;

y(4:4:end,2) = conj(x3);
y(4:4:end,3) = -conj(x2);
y(4:4:end,4) = -x1;