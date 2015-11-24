%% OSTBC Decoder for 4x2 MIMO
%
% ECE 6604: 4G MIMO Research Project
% Klaus Okkelberg and Abhishek Obla Hema

function y = fun_OSTBCDec4x2(x,chan)
% Decoder for
% Lt = 4, R = 3/4 code
% C = [ s1   s2   s3    0;
%      -s2*  s1*   0   s3;
%       s3*   0  -s1*  s2;
%        0   s3* -s2* -s1]
%
% Decode using augmented matrix
% [y y*].' = H*[x x*].'
% where H = [H1 H2; H2* H1*]

N = size(x,1);
% calculate y with 0 every 4th element
y = zeros(N,1);

for idx = 1:4:N
    H1 = [chan(idx,1:3,1); chan(idx,1:3,2);
        0 0 chan(idx+1,4,1); 0 0 chan(idx+1,4,2);
        0 chan(idx+2,4,1) 0; 0 chan(idx+3,4,2) 0;
        -chan(idx+3,4,1) 0 0; -chan(idx+3,4,2) 0 0];
    H2 = [zeros(2,3);
        chan(idx+1,2,1) -chan(idx+1,1,1) 0;
        chan(idx+1,2,2) -chan(idx+1,1,2) 0;
        -chan(idx+2,3,1) 0 chan(idx+2,1,1);
        -chan(idx+2,3,2) 0 chan(idx+2,1,2);
        0 -chan(idx+3,3,1) chan(idx+3,2,1);
        0 -chan(idx+3,3,2) chan(idx+3,2,2)];
    H = [H1 H2; conj(H2) conj(H1)];
    xblk = x(idx:idx+3,:).';
    yAug = H\[xblk(:); conj(xblk(:))];
    y(idx:idx+2) = yAug(1:3);
end

% remove extra entries
y(4:4:end) = [];