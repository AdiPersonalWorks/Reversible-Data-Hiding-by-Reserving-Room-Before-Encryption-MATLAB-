function [hist, LN, LM, RN, RM] = histGen(I,pixelFlag)
%%
% This function is used to generate the histogram of the 
% estimating errors of I

hist = zeros(511,1);
start = 256;

[h,w] = size(I);

for i=2:h-1
    for j=2:w-1
        if mod(i+j,2) == pixelFlag
            val = I(i,j);
            C = I(i-1:i+1,j-1:j+1);
            x_mean = 0.25 * ( C(2,1) + C(2,3) + C(1,2) + C(3,2) );
            xe_0 = 0.5 * ( C(2,1) + C(2,3) );
            xe_90 = 0.5 * ( C(1,2) + C(3,2) );
            S_0 = [ C(2,1) C(2,3) xe_0 ];
            S_90= [ C(1,2) C(3,2) xe_90 ];
            sigma_0 = 1/3 * sum( (S_0-x_mean).^2 );
            sigma_90 = 1/3 * sum( (S_90-x_mean).^2 );
            w_0 = sigma_90 / ( sigma_0 + sigma_90 + 1e-6 );
            w_90 = sigma_0 / ( sigma_0 + sigma_90 + 1e-6 );
            pred = round( w_0 * xe_0 + w_90 * xe_90 );
            delta = val - pred; 
            hist(delta+start) = hist(delta+start) + 1;                   
        end
    end
end

% find two peak bins on both sides
[~,sortIndex]=sort(hist);
LM = sortIndex(511) - start;   
RM = sortIndex(510) - start;

if LM > RM % check the relationship
    temp = LM;
    LM = RM;
    RM = temp;
end

i = LM + start;
while hist(i) ~= 0
    i = i-1;
end
LN = i - start;   

     
i = RM + start;
while hist(i) ~= 0
    i = i+1;
end
RN = i - start;        







