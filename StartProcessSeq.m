function StartProcessSeq(I)

clc;
warning off;

%% Change directory
prev_dir = pwd; file_dir = fileparts(mfilename('fullpath')); cd(file_dir);
addpath(genpath(pwd));

%% Main code begins here(Use provided pgm files for data hiding)
% I = double(imread(uigetfile('*.pgm','Select the required image(*.pgm) file')));
embedRate = 0.5;
[wI,actualEmbedRate,PSNR,wIdecrypt,invalid] = RRBE(I,embedRate);

if invalid==1
    return;
end

figure,imshow(I/255),title('Original image without hidden data');
figure,imshow(wIdecrypt/255),title('Decrypted Final Image'); 
fprintf('The PSNR of the final image is: %.2f dB \n',PSNR);
fprintf('The actual embedding rate is %.2f bpp \n',actualEmbedRate);

end