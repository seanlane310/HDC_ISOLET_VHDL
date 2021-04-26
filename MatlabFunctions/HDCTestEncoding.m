%% Encoding Test Inputs
clc;
clear all;

% Set global variables
classes = 6; %      Number of different letters being used
records = 1; %     Number of audio samples to be recorded
bins = 1000; %      Number of sections audio is split into

preloadigit = load('digitHVs');
digitHV = preloaddigit.digitHV;
preloadpos =  load('posHVs');
posHV = preloadpos.posHV;
prerecorded = load('SeanVowels1Tests.mat');

audio_sets = prerecorded.audio_sets;
for i = 1:classes
    bins_sets(:,:,i) = GetFreqBins(audio_sets(:,:,i), bins);
    for j = 1:records
        enc_HVs(j,:,i) = AudioEncoder(bins_sets(j,:,i), digitHV, posHV);
    end
end


%% Sample inference test
test_HVs = enc_HVs(records,:,:);

for i = 1:classes
    for j = 1:classes
        fprintf("%i\n", sum(xor(class_HVs(i,:),test_HVs(1,:,j))));
    end
    fprintf("%i\n\n", sum(xor(class_HVs(i,:),class_HVs((mod(i,3)+1),:))));
end


function [bin_values] = GetFreqBins(audioData, num_bins)
%% Frequency Bin Generation
% Turns audio samples into sets of frequency bins.
%
% Takes audioData, the audio samples.
% Takes num_bins, the number of bins of the audio samples.
%
% Returns bin_values, the set of bin values split into sections.

    num_takes = size(audioData,2);

    X(:,1:num_takes) = fft(audioData(:,1:num_takes));
    
    for s = 1:num_takes
        Z(:,s) = abs(X(:,s));
    end
    
    total = length(1:length(X(:,1))/16);
    
    binsize = total/num_bins;
    
    for s = 1:num_takes
        for i = 1:num_bins
            average(s,i) = mean(Z(round((i*binsize)+1):round((i+1)*binsize),s));
        end
    end
    
    bin_values = average;
end


function [audio_HV] = AudioEncoder(bin_values, digit_HVs, pos_HVs)
%% Audio-Hypervector Encoding
% Encodes the audio sample into one hypervector using the audio bins and
%       digit and bin position hypervectors.
%
% Takes bin_values, the set of decimal numbers representing the average
%       frequency values of one audio sample.
% Takes digit_HVs, the set of 10 hypervectors, each corresponding to a
%       digit (the number 0 through 9).
% Takes pos_HVs, the set of hypervectors corresponding to the positions of
%       the bins of the audio sample.
%
% Returns audio_HV, the hypervector representation of the audio sample
    
    for i = 1:length(bin_values)
        scaled_bins(i) = round(bin_values(i),4);
    end
    
    for i = 1:length(scaled_bins)
        level_HVs(i,:) = BinEncoder(scaled_bins(i), digit_HVs);
    end
    
    audio_HV = level_HVs(1,:) .* pos_HVs(1,:);
    for i = 2:length(level_HVs(1))
        audio_HV = audio_HV + (level_HVs(i,:) .* pos_HVs(i,:));
    end
end


function [binHV] = BinEncoder(bin_value, digit_HVs)
%% Bin-Hypervector Encoding
% Encodes one bin into one hypervector using the digit hypervectors.
%
% Takes bin_value, the decimal number representing the average
%       frequency value of one part of the audio sample.
% Takes digit_HVs, the set of 10 hypervectors, each corresponding to a
%       digit (the number 0 through 9).
%
% Returns audio_HV, the hypervector representation of that bin.

    bin_digi = bin_value * 10000;
    
    for i=1:5
        digit_rev(i) = fix(mod(bin_digi,10));
        bin_digi = floor(bin_digi/10);
    end
    
    product = digit_HVs(digit_rev(5)+1,:);
    for i=4:-1:1
        product = product + circshift(digit_HVs(fix(floor(digit_rev(i)+1)),:),5-i);
    end
    
    for i = 1:length(product)
        binHV(i) = floor(product(i)/3);
    end

end
