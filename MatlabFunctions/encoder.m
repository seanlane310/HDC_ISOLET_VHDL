%% ENCODE

max = -1;
for i = 1:length(average)
    if (abs(average(i)) > max)
        max = abs(average(i));
    end
end

for i = 1:length(average)
    scaled(i) = average(i)/max;
    scaled(i) = floor(scaled(i) * 10000)/10000;
    
end

sum = HVEncoder(scaled(1),BaseVectors);

for i = 2:length(scaled)
    sum = sum + HVEncoder(scaled(i),BaseVectors);
end

sum

function [binHV] = HVEncoder(bin, digitHVs)

    bind = bin * 10000;
    
    for i=1:5
        digitR(i) = mod(bind,10);
        bind = floor(bind/10);
    end
    
    product = digitHVs(digitR(5)+1,:);
    for i=4:-1:1
        product = product .* circshift(digitHVs(fix(floor(digitR(i)+1)),:),5-i);
    end
    
    binHV = product;

end
