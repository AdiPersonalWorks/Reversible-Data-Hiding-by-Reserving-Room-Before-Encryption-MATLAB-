function [finalA,finalB,index] = imgPartition(I,H)
%%
% This function is to find A, which has the most complex texture.

I = round(I);
[m,n] = size(I);
N = m - H + 1; % No of blocks
f = zeros(N,1);

for i = 1:N
    A = I(i: i - 1 + H,1:n);
    [h,w] = size(A); % h and w are rows and columns for the block
    for j = 1:h
        for k = 1:w
            if h == 1          %I contains only one row.
                if j == 1 && k == 1                  %four corners
                    val = abs( A(j,k) - (A(j,k+1))/1);
                elseif j == 1 && k == w
                    val = abs( A(j,k) - (A(j,k-1))/1 );
                else
                    val = abs( A(j,k) - (A(j,k-1) + A(j,k+1))/2 );
                end
            else
                if j == 1 && k == 1                  %four corners
                    val = abs( A(j,k) - (A(j+1,k) + A(j,k+1))/2 );
                elseif j == 1 && k == w
                    val = abs( A(j,k) - (A(j+1,k) + A(j,k-1))/2 );                
                elseif j == h && k == 1
                    val = abs( A(j,k) - (A(j-1,k) + A(j,k+1))/2 );
                elseif j == h && k == w
                    val = abs( A(j,k) - (A(j-1,k) + A(j,k-1))/2 );
                elseif j == 1                        %four boundaries
                    val = abs( A(j,k) - (A(j+1,k) + A(j,k+1) + A(j,k-1))/3 );
                elseif j == h
                    val = abs( A(j,k) - (A(j-1,k) + A(j,k+1) + A(j,k-1))/3 );
                elseif k == 1
                    val = abs( A(j,k) - (A(j-1,k) + A(j+1,k) + A(j,k+1))/3 );
                elseif k == w
                    val = abs( A(j,k) - (A(j-1,k) + A(j+1,k) + A(j,k-1))/3 );
                else
                    val = abs( A(j,k) - (A(j-1,k) + A(j+1,k) + A(j,k-1) + A(j,k+1))/4 );
                end
            end
            f(i) = f(i) + val;
        end
    end
    f(i) = f(i)/( h*w );
end
[~,index] = max(f);

%divide I into A and B
if index == N
    finalA =  I(index : end, 1:n);
    finalB = I(1: index - 1, 1:n);
elseif index == 1
    finalA = I(index : index + H -1 , 1:n);
    finalB = I(index + H : end, 1:n);
else
    finalA = I(index : index + H -1, 1:n);
    finalB = [I(1:index -1, 1:n);
         I(index + H : end, 1:n)];
end
