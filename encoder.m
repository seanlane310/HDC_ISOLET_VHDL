%% Testing AudioEncoder
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

bins(1) = 0.2467;
bins(2) = 1.0000;
bins(3) = 4.3246;

posit(1,:) = [1,-1,1,-1,1];
posit(2,:) = [1,-1,1,-1,1];
posit(3,:) = [1,-1,1,-1,1];

audioHV = AudioEncoder(bins, digitHVs, posit)

%% AudioEncoder Function
% for random set of digitHVs where digits 0-9 --> HVs[1] - HVs[10]
%       and bins where each is a decimal number
%       and random set of positionHVs where indexed by bin position in
%       audio sample (1st = HVs[1], 2nd = HVs[2], etc)
%
% scales bins to -1.0000 to 1.0000 then for each gets levelHV using
%       BinEncoder with the digitHVs
%
% use levelHVs and multiply with positionHVs to get sum of products to be
%       returned as audioHV by function

function [audioHV] = AudioEncoder(bins, digitHVs, positionHVs)
    
    bin_max = -1;
    for i = 1:length(bins)
        if (abs(bins(i)) > bin_max)
            bin_max = abs(bins(i));
        end
    end
    
    for i = 1:length(bins)
        scaled_bins(i) = bins(i)/bin_max;
        scaled_bins(i) = floor(scaled_bins(i) * 10000)/10000;
    end
    
    for i = 1:length(scaled_bins)
        levelHVs(i,:) = BinEncoder(scaled_bins(i), digitHVs);
    end
    
    audioHV = levelHVs(1,:) .* positionHVs(1,:);
    for i = 2:length(levelHVs(1))
        audioHV = audioHV + levelHVs(i,:) .* positionHVs(i,:);
    end
    
end

%% BinEncoder Function
% for random set of HVs where digits 0-9 --> HVS[1] - HVS[10]
% get digits of bin (x.xxxx) by times 10,000 then mod 10 and div 10
% use digits to get HV for each digit then perm and multiply for bin HV

function [binHV] = BinEncoder(bin, digitHVs)

    bin_digi = bin * 10000;
    
    for i=1:5
        digitR(i) = mod(bin_digi,10);
        bin_digi = floor(bin_digi/10);
    end
    
    product = digitHVs(digitR(5)+1,:);
    for i=4:-1:1
        product = product .* circshift(digitHVs(fix(floor(digitR(i)+1)),:),5-i);
    end
    
    binHV = product;

end
