function PSNR = psnr(I,W)
%%
% This function is used to calculate the PSNR between two images.

[m,n] = size(I);
[h,w] = size(W);
if m ~= h && n ~= w
    error('Two images must have the same size.')
end
delta = 1/(m*n) * sum( ( I(:) - W(:) ).^2 );
PSNR = 10 * log10( 255^2/delta );