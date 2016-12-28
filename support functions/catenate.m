function I = catenate(A,B,index,H)
%%
% This function is to catenate A and B into I according to the index.

N =  size(A,1) + size(B,1) - H + 1; 
if index == N
   I = [B;A];
elseif index == 1
   I = [A;B];
else
    I= [B(1:index-1, 1:size(A,2));
         A;
         B(index : end, 1:size(A,2))];
end