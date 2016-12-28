function d = decryptA(A,data)
%%
% This function is to extract data from the LSB-planes of A.
% [h,w] = size(A);

%Retrieve LSB's from part A
if 1
    m = mod(A,2);
    m = m(:);
    W = A(:);
    m = m(1:length(data));
end

%Recovering the embedded string
m = num2str(m)';
req_embedded_string = char(bin2dec(reshape(m,8,[]).').');
d = req_embedded_string;
disp_req_string = ['The Embedded Message is : ' req_embedded_string];
disp(disp_req_string);

