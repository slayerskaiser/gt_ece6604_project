%% OSTBC Decoder for 4x2 MIMO
%
% ECE 6604: 4G MIMO Research Project
% Klaus Okkelberg and Abhishek Obla Hema

function y = fun_OSTBC2Dec4x2(x,chan)
% Decoder for
% Lt = 4, R = 1/2 code
% C = [ s1   s2   s3   s4;
%      -s2   s1  -s4   s3;
%      -s3   s4   s1  -s2;
%      -s4  -s3   s2   s1;
%       s1*  s2*  s3*  s4*;
%      -s2*  s1* -s4*  s3*;
%      -s3*  s4*  s1* -s4*;
%      -s4* -s3*  s2*  s1;

N = size(x,1);
% calculate y with 0 every 5th-8th element
y = zeros(N,1);

inds = [5:8:N; 6:8:N; 7:8:N; 8:8:N];
x(inds,:) = conj(x(inds,:));
for idx = 1:8:N
    H1 = [chan(idx,:,1); chan(idx,:,2);
        chan(idx+1,2,1) -chan(idx+1,1,1) chan(idx+1,4,1) -chan(idx+1,3,1);
        chan(idx+1,2,2) -chan(idx+1,1,2) chan(idx+1,4,2) -chan(idx+1,3,2);
        chan(idx+2,3,1) -chan(idx+2,4,1) -chan(idx+2,1,1) chan(idx+2,2,1);
        chan(idx+2,3,2) -chan(idx+2,4,2) -chan(idx+2,1,2) chan(idx+2,2,2);
        chan(idx+3,4,1) chan(idx+3,3,1) -chan(idx+3,2,1) -chan(idx+3,1,1);
        chan(idx+3,4,2) chan(idx+3,3,2) -chan(idx+3,2,2) -chan(idx+3,1,2)];
    H2 = [chan(idx+4,:,1); chan(idx+4,:,2);
        chan(idx+5,2,1) -chan(idx+5,1,1) chan(idx+5,4,1) -chan(idx+5,3,1);
        chan(idx+5,2,2) -chan(idx+5,1,2) chan(idx+5,4,2) -chan(idx+5,3,2);
        chan(idx+6,3,1) -chan(idx+6,4,1) -chan(idx+6,1,1) chan(idx+6,2,1);
        chan(idx+6,3,2) -chan(idx+6,4,2) -chan(idx+6,1,2) chan(idx+6,2,2);
        chan(idx+7,4,1) chan(idx+7,3,1) -chan(idx+7,2,1) -chan(idx+7,1,1);
        chan(idx+7,4,2) chan(idx+7,3,2) -chan(idx+7,2,2) -chan(idx+7,1,2)];
    y(idx:idx+3) = [H1; conj(H2)]\reshape(x(idx:idx+7,:).',16,1);
end

% remove extra entries
y(inds) = [];