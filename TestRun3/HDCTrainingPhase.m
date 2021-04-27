%% Training Phase Execution
clc;
clear all;

% Set global variables
classes = 6; %      Number of different letters being used
records = 33; %     Number of audio samples to be recorded
bins = 1000; %      Number of sections audio is split into

%use if need to generate HVs
[digitHV, posHV] = GetBaseHVs(bins);

%use if have presaved HVs
% preloaddigit = load('digitHVs');
% digitHV = preloaddigit.digitHV;
% preloadpos =  load('posHVs');
% posHV = preloadpos.posHV;
prerecorded = load('SeanVowels33Trials.mat');
audio_sets = prerecorded.audio_sets;

for i = 1:classes
    bins_sets(:,:,i) = GetFreqBins(audio_sets(:,:,i), bins);
    for j = 1:records
        enc_HVs(j,:,i) = AudioEncoder(bins_sets(j,:,i), digitHV, posHV);
    end
end

% if even, subtract 1; if odd, leave be
last_hv = ((records - 1) + mod(records,2));
class_HVs = Train(enc_HVs(1:last_hv,:,:));

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


function [digit_HVs, pos_HVs] = GetBaseHVs(num_bins)
%% Initial Hypervector Generation
% Gives 2 hypervector sets: the 10 digit vectors and a number of position
%       vectors dependent on the number of audio bins.
%
% Takes num_bins, the number of bins of the audio samples.
%
% Returns digit_HVs, the set of 10 hypervectors corresponding to the
%       numbers 0 through 9.
% Returns pos_HVs, the set of hypervectors corresponding to the
%       positions of the bins of the audio sample.

    D = 10000;
    M = 10;
    
%     num_HVs(1,:) = randi([0,1],1,D);
%     for d = 2:10
%         num_HVs(d,:) = num_HVs(d-1,:);
%         rand = randi(D,(D/M-d),1);
%         for i = 1:length(rand)
%             num_HVs(d,rand(i)) = ~num_HVs(d,rand(i));
%         end
%     end
%     
%     for d = 1:M
%         for i = 1:length(rand)
%             if (num_HVs(d,i) == 0)
%                 num_HVs(d,i) = -1;
%             end
%         end
%     end
    
    
    for p = 1:M
        num_HVs(p,:) = randi([0,1],1,D);
    end
    for d = 1:M
        for i = 1:D
            if (num_HVs(d,i) == 0)
                num_HVs(d,i) = -1;
            end
        end
    end
    
    for p = 1:num_bins
        ID_HVs(p,:) = randi([0,1],1,D);
    end
    
    digit_HVs = num_HVs;
    pos_HVs = ID_HVs;

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
        product = product .* circshift(digit_HVs(fix(floor(digit_rev(i)+1)),:),5-i);
    end
   
    for i = 1:length(product)
        if (product(i) == -1)
            binHV(i) = 0;
        else
            binHV(i) = product(i);
        end
    end
    
end


function [class_HVs] = Train(HV_sets)
%% Training Function
% Takes HV_sets, a three-dimensional array that represents the full set of
%       all of the hypervectors, where each is a one-dimensional array, and
%       they are organized into two-dimensional arrays based on the class.
% 
% Returns class_HVs, a two-dimensional array of the trained class
%       hypervectors that are represented as one-dimensional arrays

    for i = 1:size(HV_sets,3)
        class_set = HV_sets(:,:,i);
        div_num = ((size(class_set,1) + 1)/2);
        
        for j = 1:size(class_set,2)
            col_sum = sum(class_set(:,j));
            class_HVs(i,j) = fix(abs(col_sum/div_num));
        end
    end

end