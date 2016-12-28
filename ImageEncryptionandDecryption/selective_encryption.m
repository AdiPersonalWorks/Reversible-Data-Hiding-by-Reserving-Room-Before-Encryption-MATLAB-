function [a1,return_val] = selective_encryption(im)
%%
% This is the main code for selective encryption.
%
% The input arguments to the function are:
%   1. im: This argument contains the image in which the data has been
%   hidden.
%
% The output arguments are:
%   1. a1 = This passes back the image after decryption.

return_val = 0;

tic

im1=im(:,:,1);
z=input('Select the key for Image Encryption-> ') ;
z1=z;

figure;
subplot(2,2,1);imshow((im1/255));
title('Input Image with Hidden Data');
im2=double(im1);
[M,N]=size(im2);
e=hundungen(M,N,0.1);
tt=0.001;
im3=mod(tt*im2+(1-tt)*e,256);
a1(:,:,1)=round(im3(:,:,1));a1(:,:,2)=im(:,:,2);a1(:,:,3)=im(:,:,3);
for i=1:400
    for j=1:400
        a1(i,j,1)=bitxor (a1(i,j,3),a1(i,j,1));
        a1(i,j,2)=bitxor (a1(i,j,1),a1(i,j,2));
        a1(i,j,3)=bitxor (a1(i,j,2),a1(i,j,3));
    end
end
for i=1:400
    for j=1:400
        a1(i,j,1)=bitxor (a1(i,j,3),a1(i,j,2));
        a1(i,j,2)=bitxor (a1(i,j,1),a1(i,j,3));
        a1(i,j,3)=bitxor (a1(i,j,2),a1(i,j,1));
    end
end

subplot(2,2,2);imshow(uint8(a1),[]);
title('Encrypted Image with Hidden Data');
toc

% -----------------------------------------------------------------
if (z1==input('Enter the key for image decryption-> '))
    tic
    e=keygen(M,N,0.1);
    im5=(im3-(1-tt)*e)/tt;
    a1(:,:,1)=round(im5(:,:,1));a1(:,:,2)=im(:,:,2);a1(:,:,3)=im(:,:,3);
    subplot(2,2,3);imshow(uint8(a1),[]);
    title('Decrypted Image with Hidden Data');
    figure(4);
    subplot(231)
    imhist(uint8(im1));
    title('Histogram of the Input image');
    subplot(233)
    imhist(uint8(im3));
    title('Histogram of the Encrypted image');
    subplot(234)
    imhist(uint8(im5));
    title('Histogram of the final Image');
else
    input('Wrong Image decryption key entered');
    return_val = 1;
end
toc