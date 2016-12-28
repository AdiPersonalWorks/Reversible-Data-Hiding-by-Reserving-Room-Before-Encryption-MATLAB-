function W = embedA(A,d,index)
%% 
% This function is to embed data into LSB-planes of A.

[h,w] = size(A);
if ~index
    m = mod(A,2);
    m = m(:); % All to replace LSB's.
    W = A(:); % 2D - 1D array
    W(1:length(d)) = W(1:length(d)) - m(1:length(d)) + d;  % LSB replacement. 
else
    m1 = mod(A,2);
    m2 = mod(floor(A/2),2);
    m1 = m1(:);
    m2 = m2(:);
    W = A(:);
    if length(m1) > length(d)
        W(1:length(d)) = W(1:length(d)) - m1(1:length(d)) + d; 
    else
        W = W - m1 + d(1:length(m1));  
        L = length(d) - length(m1);
        W(1:L) = W(1:L) - 2 * m2(1:L) + 2 * d(length(m1) + 1:end);
    end
end
W = reshape(W,h,w); % 1D-2D






