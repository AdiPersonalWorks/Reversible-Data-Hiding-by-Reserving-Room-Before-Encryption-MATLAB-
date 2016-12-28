function [wI,actualEmbedRate,PSNR,new_wA,invalid] = RRBE(I,embedRate,T1,T2)
%========================================================================
%This is an implementation of the Reversible Data Hiding (RDH) algorithm in
%encrypted images by Reserving Room Before Encryption (RRBE).
%
%Input : (1) I: the original image, whose dynamic range is 0-255
%        (2) embedRate: embedding rate (in bpp).
%        (3) T1: threshold (in bpp) for choice of LSB-plane number of the
%            subimage A (see the above reference). default value: T1 = 0.25
%            bpp
%        (4) T2: threshold (in percentage %) for choice of embedding
%            strategies (see the above reference). default value: T2 = 20%
%
%Default Usage:
%   Given I, whose dynamic range is 0-255 and embedding rate
%   embedRate,
%   [wI,actualEmbedRate,PSNR] = RRBE(I,embedRate);
%========================================================================
invalid = 0;

if (nargin < 2 || nargin > 4)
    wI = -Inf;
    actualEmbedRate = -Inf;
    PSNR = -Inf;
    return;
end

if (nargin == 2)
    T1 = 0.25;
    T2 = 0.2;
end

if (nargin == 3)
    T2 = 0.2;
end
%----------- image partition -----------------
I = double(I);
[h,w]= size(I);
dataLength = embedRate * h * w;
if embedRate <= T1
    T1Ind = false;
    AHeight = ceil(dataLength/w);
    [A, B, AInd] = imgPartition(I, AHeight); % find proper partition of I.
else
    T1Ind = true;
    AHeight = ceil(dataLength/(w * 2));
    [A, B, AInd] = imgPartition(I, AHeight);
end

%----------- embed the data into LSB-planes of A --------------
% Added 4th Dec 2014 - Insert text : input from user

%Just a safecase
Data_Hiding_Key = '00000';
%
Hide_str = input('Enter the string you want to hide in the image-> ','s');
Data_Hiding_Key = input('Enter a data hiding key(Numeric key only)-> ','s');
Hide_str_bin = dec2bin(Hide_str,8)';
Hide_str_bin = Hide_str_bin(:)'-'0';
data = Hide_str_bin';

if length(data) > dataLength % Remove this if you want to decrease the efficiency and add data greater than the permissible length
    msgbox('Text too large for the image.Enter a smaller text to hide in the image.');
    invalid=1;
    return;
end
% data = round(rand(dataLength,1));
wA = embedA(A,data,T1Ind);

%---------- self-embedding process -------------
% record the LSB-planes of A
if ~T1Ind
    m = mod(A,2);
    m = m(:);
    m = m(1:dataLength);
else
    m1 = mod(A,2);
    m1 = m1(:);
    m2 = mod(floor(A/2),2);
    m2 = m2(:);
    m = [m1;m2];
    m = m(1:dataLength);
end
embeddingRound = 1;
fprintf('  Embedding round %d:\n ',embeddingRound);
[wB,payload,boundaryMap,multiInd]= embedB(B,m,T2);
while multiInd % multilayer embedding is needed.
    embeddingRound = embeddingRound + 1;
    %     fprintf(' Embedding round %d:\n ',embeddingRound);
    d = m(payload + 1:end);
    [wB,payload_m,boundaryMap_m,multiInd]= embedB(wB,d,T2);
    payload = payload + payload_m;
    boundaryMap = [boundaryMap;boundaryMap_m];
end
%---------- con-catenate W_A and W_B -------------
wI = catenate(wA,wB,AInd,AHeight);

%-----------Passing the concatenated image for encryption---------
% Creating a new 3 plane image to pass to the encryption algorithm from the
% exisiting 1 plane image

wI_3plane(:,:,1) = wI;
wI_3plane(:,:,2) = wI;
wI_3plane(:,:,3) = wI;

[decrypted_image,return_val] = selective_encryption(wI_3plane);
if return_val == 1
    invalid=1;
    return;
end
new_wA = decrypted_image(:,:,1);

%---------- calculation of PSNR and actual embedding rate -------------
PSNR = psnr(I,wI);
actualEmbedRate = payload /(h*w);

%------Decryption of image and extracting the hidden message-----%
Data_Hiding_Key_Decrypt = input('Enter the necessary data hiding key to view the hidden message->','s');
if strcmp(Data_Hiding_Key_Decrypt,Data_Hiding_Key)
    %     data = decryptA(new_wA,data);
    data = decryptA(wA,data);
else
    msgbox('Invalid Key Entered','Data Hiding Key Message');
    invalid=1;
    return;
end