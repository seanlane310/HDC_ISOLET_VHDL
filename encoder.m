clc; clear all; close all;

digitHVs(1,:) = [1,-1,1,-1,1];
digitHVs(2,:) = [1,-1,1,-1,1];
digitHVs(3,:) = [1,-1,1,-1,1];
digitHVs(4,:) = [1,-1,1,-1,1];
digitHVs(5,:) = [1,-1,1,-1,1];
digitHVs(6,:) = [1,-1,1,-1,1];
digitHVs(7,:) = [1,-1,1,-1,1];
digitHVs(8,:) = [1,-1,1,-1,1];
digitHVs(9,:) = [1,-1,1,-1,1];
digitHVs(10,:) = [1,-1,1,-1,1];
binHV = encoder(0.2467,digitHVs);

for i=1:5
    fprintf("%4.2f\n",binHV(i));
end

% for random set of HVs where 0-9 --> HVS[0] - HWS[9]
% get digits of x.xxxx by times 10,000 then mod 10 for each digit
% use digits to get HV for each digit then perm and multiply

function [binHV] = encoder(bin, digitHVs)

    bind = bin * 10000;
    
    for i=1:5
        digitR(i) = mod(bind,10);
        bind = floor(bind/10);
    end
    
    product = digitHVs(digitR(5)+1,:);
    for i=4:-1:1
        product = product .* circshift(digitHVs(digitR(i)+1,:),5-i);
    end
    
    binHV = product;

end