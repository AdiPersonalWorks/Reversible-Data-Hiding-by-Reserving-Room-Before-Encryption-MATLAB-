function [W,payload,boundaryMap] = embedBlack(I,d,p)
%%
% This function is to embed messages into black pixels.

[h,w] = size(I);
LN = p(1); RN = p(4);
LM = p(2);  RM = p(3); 

boundaryMap = zeros(1000,1);
bmIndex = 0;
dataIndex = 0;
W = I;

for i = 2:h-1
    for j = 2:w-1
        if dataIndex < length(d) &&  mod(i+j,2)== 1
        val = W(i,j);
        if val==0 || val==255             %boundary pixel
            bmIndex = bmIndex + 1;
            boundaryMap(bmIndex) = 0; 
        else
            C = W(i-1:i+1,j-1:j+1);
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
            e = val - pred; %calculate the error
            % embedding process
            if e==LM || e==RM   % peak bin pixel
                dataIndex = dataIndex + 1;
                b = d(dataIndex);     
                if e==LM
                    e_new = e-b;
                else
                    e_new = e+b;
                end              
            elseif  ( LN<e && e<LM ) || ( RM<e && e<RN ) 
                if LN<e && e<LM
                    e_new = e-1;
                else
                    e_new = e+1;
                end
            else           
                e_new = e;              
            end
            
            val_new = pred + e_new;
            W(i,j) = val_new;
            if val_new==0 || val_new==255
                bmIndex = bmIndex + 1;
                boundaryMap(bmIndex) = 1;   
            end             

        end 
        end
    end
end
payload = dataIndex;
boundaryMap = boundaryMap(1:bmIndex);