%% OSTBC Encoder for 8 Tx
%
% ECE 6604: 4G MIMO Research Project
% Klaus Okkelberg and Abhishek Obla Hema

function y = fun_OSTBC2Enc8x(x)
% Lt = 8, R = 1/2 code
% C = [ s1   s2   s3   s4   s5   s6   s7   s8;
%      -s2   s1   s4  -s3   s6  -s5  -s8   s7;
%      -s3  -s4   s1   s2   s7   s8  -s5  -s6;
%      -s4   s3  -s2   s1   s8  -s7   s6  -s5;
%      -s5  -s6  -s7  -s8   s1   s2   s3   s4;
%      -s6   s5  -s8   s7  -s2   s1  -s4   s3;
%      -s7   s8   s5  -s6  -s3   s4   s1  -s2;
%      -s8  -s7   s6   s5  -s4  -s3   s2   s1;
%       s1*  s2*  s3*  s4*  s5*  s6*  s7*  s8*;
%      -s2*  s1*  s4* -s3*  s6* -s5* -s8*  s7*;
%      -s3* -s4*  s1*  s2*  s7*  s8* -s5* -s6*;
%      -s4*  s3* -s2*  s1*  s8* -s7*  s6* -s5*;
%      -s5* -s6* -s7* -s8*  s1*  s2*  s3*  s4*;
%      -s6*  s5* -s8*  s7* -s2*  s1* -s4*  s3*;
%      -s7*  s8*  s5* -s6* -s3*  s4*  s1* -s2*;
%      -s8* -s7*  s6*  s5* -s4* -s3*  s2*  s1* ]

N = length(x);
y = zeros(2*N,8);
x1 = x(1:8:end);
x2 = x(2:8:end);
x3 = x(3:8:end);
x4 = x(4:8:end);
x5 = x(5:8:end);
x6 = x(6:8:end);
x7 = x(7:8:end);
x8 = x(8:8:end);

y(1:16:end,:) = [x1 x2 x3 x4 x5 x6 x7 x8];
y(2:16:end,:) = [-x2 x1 x4 -x3 x6 -x5 -x8 x7];
y(3:16:end,:) = [-x3 -x4 x1 x2 x7 x8 -x5 -x6];
y(4:16:end,:) = [-x4 x3 -x2 x1 x8 -x7 x6 -x5];
y(5:16:end,:) = [-x5 -x6 -x7 -x8 x1 x2 x3 x4];
y(6:16:end,:) = [-x6 x5 -x8 x7 -x2 x1 -x4 x3];
y(7:16:end,:) = [-x7 x8 x5 -x6 -x3 x4 x1 -x2];
y(8:16:end,:) = [-x8 -x7 x6 x5 -x4 -x3 x2 x1];
for k = 9:16
    y(k:16:end,:) = conj(y(k-8:16:end,:));
end
