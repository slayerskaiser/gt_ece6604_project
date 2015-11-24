%% OSTBC Decoder for 8x2 MIMO
%
% ECE 6604: 4G MIMO Research Project
% Klaus Okkelberg and Abhishek Obla Hema

function y = fun_OSTBC2Dec8x2(x,chan)
% Decoder for
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

N = size(x,1);
% calculate y with 0 every 9th-16th element
y = zeros(N,1);

inds = [9:16:N; 10:16:N; 11:16:N; 12:16:N;
    13:16:N; 14:16:N; 15:16:N; 16:16:N];
x(inds,:) = conj(x(inds,:));
for idx = 1:16:N
    H1 = [chan(idx,:,1); chan(idx,:,2);
        chan(idx+1,2,1) -chan(idx+1,1,1) -chan(idx+1,4,1) chan(idx+1,3,1) ...
        -chan(idx+1,6,1) chan(idx+1,5,1) chan(idx+1,8,1) -chan(idx+1,7,1);
        chan(idx+1,2,2) -chan(idx+1,1,2) -chan(idx+1,4,2) chan(idx+1,3,2) ...
        -chan(idx+1,6,2) chan(idx+1,5,2) chan(idx+1,8,2) -chan(idx+1,7,2);
        chan(idx+2,3,1) chan(idx+2,4,1) -chan(idx+2,1,1) -chan(idx+2,2,1) ...
        -chan(idx+2,7,1) -chan(idx+2,8,1) chan(idx+2,5,1) chan(idx+2,6,1);
        chan(idx+2,3,2) chan(idx+2,4,2) -chan(idx+2,1,2) -chan(idx+2,2,2) ...
        -chan(idx+2,7,2) -chan(idx+2,8,2) chan(idx+2,5,2) chan(idx+2,6,2);
        chan(idx+3,4,1) -chan(idx+3,3,1) chan(idx+3,2,1) -chan(idx+3,1,1) ...
        -chan(idx+3,8,1) chan(idx+3,7,1) -chan(idx+3,6,1) chan(idx+3,5,1);
        chan(idx+3,4,2) -chan(idx+3,3,2) chan(idx+3,2,2) -chan(idx+3,1,2) ...
        -chan(idx+3,8,2) chan(idx+3,7,2) -chan(idx+3,6,2) chan(idx+3,5,2);
        chan(idx+4,5:8,1) -chan(idx+4,1:4,1);
        chan(idx+4,5:8,2) -chan(idx+4,1:4,2);
        chan(idx+5,6,1) -chan(idx+5,5,1) chan(idx+5,8,1) -chan(idx+5,7,1) ...
        chan(idx+5,2,1) -chan(idx+5,1,1) chan(idx+5,4,1) -chan(idx+5,3,1);
        chan(idx+5,6,2) -chan(idx+5,5,2) chan(idx+5,8,2) -chan(idx+5,7,2) ...
        chan(idx+5,2,2) -chan(idx+5,1,2) chan(idx+5,4,2) -chan(idx+5,3,2);
        chan(idx+6,7,1) -chan(idx+6,8,1) -chan(idx+6,5,1) chan(idx+6,6,1) ...
        chan(idx+6,3,1) -chan(idx+6,4,1) -chan(idx+6,1,1) chan(idx+6,2,1);
        chan(idx+6,7,2) -chan(idx+6,8,2) -chan(idx+6,5,2) chan(idx+6,6,2) ...
        chan(idx+6,3,2) -chan(idx+6,4,2) -chan(idx+6,1,2) chan(idx+6,2,2);
        chan(idx+7,8,1) chan(idx+7,7,1) -chan(idx+7,6,1) -chan(idx+7,5,1) ...
        chan(idx+7,4,1) chan(idx+7,3,1) -chan(idx+7,2,1) -chan(idx+7,1,1);
        chan(idx+7,8,2) chan(idx+7,7,2) -chan(idx+7,6,2) -chan(idx+7,5,2) ...
        chan(idx+7,4,2) chan(idx+7,3,2) -chan(idx+7,2,2) -chan(idx+7,1,2)];
    H2 = [chan(idx+8,:,1); chan(idx+8,:,2);
        chan(idx+9,2,1) -chan(idx+9,1,1) -chan(idx+9,4,1) chan(idx+9,3,1) ...
        -chan(idx+9,6,1) chan(idx+9,5,1) chan(idx+9,8,1) -chan(idx+9,7,1);
        chan(idx+9,2,2) -chan(idx+9,1,2) -chan(idx+9,4,2) chan(idx+9,3,2) ...
        -chan(idx+9,6,2) chan(idx+9,5,2) chan(idx+9,8,2) -chan(idx+9,7,2);
        chan(idx+10,3,1) chan(idx+10,4,1) -chan(idx+10,1,1) -chan(idx+10,2,1) ...
        -chan(idx+10,7,1) -chan(idx+10,8,1) chan(idx+10,5,1) chan(idx+10,6,1);
        chan(idx+10,3,2) chan(idx+10,4,2) -chan(idx+10,1,2) -chan(idx+10,2,2) ...
        -chan(idx+10,7,2) -chan(idx+10,8,2) chan(idx+10,5,2) chan(idx+10,6,2);
        chan(idx+11,4,1) -chan(idx+11,3,1) chan(idx+11,2,1) -chan(idx+11,1,1) ...
        -chan(idx+11,8,1) chan(idx+11,7,1) -chan(idx+11,6,1) chan(idx+11,5,1);
        chan(idx+11,4,2) -chan(idx+11,3,2) chan(idx+11,2,2) -chan(idx+11,1,2) ...
        -chan(idx+11,8,2) chan(idx+11,7,2) -chan(idx+11,6,2) chan(idx+11,5,2);
        chan(idx+12,5:8,1) -chan(idx+12,1:4,1);
        chan(idx+12,5:8,2) -chan(idx+12,1:4,2);
        chan(idx+13,6,1) -chan(idx+13,5,1) chan(idx+13,8,1) -chan(idx+13,7,1) ...
        chan(idx+13,2,1) -chan(idx+13,1,1) chan(idx+13,4,1) -chan(idx+13,3,1);
        chan(idx+13,6,2) -chan(idx+13,5,2) chan(idx+13,8,2) -chan(idx+13,7,2) ...
        chan(idx+13,2,2) -chan(idx+13,1,2) chan(idx+13,4,2) -chan(idx+13,3,2);
        chan(idx+14,7,1) -chan(idx+14,8,1) -chan(idx+14,5,1) chan(idx+14,6,1) ...
        chan(idx+14,3,1) -chan(idx+14,4,1) -chan(idx+14,1,1) chan(idx+14,2,1);
        chan(idx+14,7,2) -chan(idx+14,8,2) -chan(idx+14,5,2) chan(idx+14,6,2) ...
        chan(idx+14,3,2) -chan(idx+14,4,2) -chan(idx+14,1,2) chan(idx+14,2,2);
        chan(idx+15,8,1) chan(idx+15,7,1) -chan(idx+15,6,1) -chan(idx+15,5,1) ...
        chan(idx+15,4,1) chan(idx+15,3,1) -chan(idx+15,2,1) -chan(idx+15,1,1);
        chan(idx+15,8,2) chan(idx+15,7,2) -chan(idx+15,6,2) -chan(idx+15,5,2) ...
        chan(idx+15,4,2) chan(idx+15,3,2) -chan(idx+15,2,2) -chan(idx+15,1,2)];
    y(idx:idx+7) = [H1; conj(H2)]\reshape(x(idx:idx+15,:).',32,1);
end

% remove extra entries
y(inds) = [];