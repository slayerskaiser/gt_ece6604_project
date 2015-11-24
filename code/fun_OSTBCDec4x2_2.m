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
%        0   s3* -s2* -s1];
%
% Decode using augmented matrix
% [y y*].' = H*[x x*].'
% where H = [H1 H2; H2* H1*]

N = size(x,1);
% calculate y with 0 every 4th element
y = zeros(N,1);

for idx = 1:4:N
    H1 = squeeze([conj(chan(idx,1,:)) chan(idx+1,2,:) ...
        -chan(idx+2,3,:) -conj(chan(idx+3,4,:))]).';
    H2 = squeeze([conj(chan(idx,2,:)) -chan(idx+1,1,:) ...
        conj(chan(idx+2,4,:)) -chan(idx+3,3,:)]).';
    H3 = squeeze([conj(chan(idx,3,:)) conj(chan(idx+1,4,:)) ...
        chan(idx+2,1,:) chan(idx+3,2,:)]).';
    y(idx) = [x(idx,:) conj(x(idx+1,:)) ...
        conj(x(idx+2,:)) x(idx+3,:)]*H1(:);
    y(idx+1) = [x(idx,:) conj(x(idx+1,:)) ...
        x(idx+2,:) conj(x(idx+3,:))]*H2(:);
    y(idx+2) = [x(idx,:) x(idx+1,:) ...
        conj(x(idx+2,:)) conj(x(idx+3,:))]*H3(:);
%     y(idx:idx+2) = y(idx:idx+2)./norm([H1 H2 H3],'fro')^2;
end

% remove extra entries
y(4:4:end) = [];