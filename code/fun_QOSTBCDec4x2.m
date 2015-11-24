%% QOSTBC Decoder for 4x2 MIMO
%
% ECE 6604: 4G MIMO Research Project
% Klaus Okkelberg and Abhishek Obla Hema

function y = fun_QOSTBCDec4x2(x,chan)
% Decoder for
% Lt = 4, R = 1 code
% C = [ s1   s2   s3   s4;
%      -s2*  s1* -s4*  s3*;
%       s3   s4   s1   s2;
%      -s4*  s3* -s2*  s1*]

N = size(x,1);
y = zeros(N,1);

x(2:4:end,:) = conj(x(2:4:end,:));
x(4:4:end,:) = conj(x(4:4:end,:));
for idx = 1:4:N
    H = [chan(idx,:,1); chan(idx,:,2);
        chan(idx+1,2,1) -chan(idx+1,1,1) chan(idx+1,4,1) -chan(idx+1,3,1);
        chan(idx+1,2,2) -chan(idx+1,1,2) chan(idx+1,4,2) -chan(idx+1,3,2);
        chan(idx+2,[3 4 1 2],1); chan(idx+2,[3 4 1 2],2);
        chan(idx+3,4,1) -chan(idx+3,3,1) chan(idx+3,2,1) -chan(idx+3,1,1);
        chan(idx+3,4,2) -chan(idx+3,3,2) chan(idx+3,2,2) -chan(idx+3,1,2)];
    H([3 4 7 8],:) = conj(H([3 4 7 8],:));
    y(idx:idx+3) = H\reshape(x(idx:idx+3,:).',8,1);
end