function [audioData] = RecordAudio11()
%% Audio Recording
% Records 2 seconds of audio 11 times, for a total of 22 seconds.
%
% Takes no parameters.
%
% Returns audioData, an array of the 11 audio recordings.

    for audioid = 1:11
        r(audioid) = audiorecorder(44100,16,1);
        record(r(audioid));
        fprintf("%i\n",audioid);
        pause(2);
        stop(r(audioid));
        fprintf("stop\n");
        x = getaudiodata(r(audioid),'double');
        y(:,audioid) = x(1:87040);
        pause(2);
    end
    
    audioData = y;
end


function [bin_values] = GetFreqBins(audioData, num_bins)
%% Frequency Bin Generation
% Turns 11 audio samples into 11 sets of frequency bins.
%
% Takes audioData, the 11 audio samples.
% Takes num_bins, the number of bins of the audio samples.
%
% Returns bin_values, the set of bin values split into 11 sections.

    X(:,1:11) = fft(audioData(:,1:11));
    
    for s = 1:11
        Z(:,s) = abs(X(:,s));
    end
    
    total = length(1:length(X(:,1))/16);
    
    binsize = total/bins;
    
    for s = 1:11
        for i = 1:num_bins
            average(s,i) = mean(Z((i*binsize)+1:((i+1)*binsize),s));
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

    D = 100;
    M = 10;
    
    num_HVs(1,:) = randi([0,1],1,num_bins);
    for d = 2:10
        num_HVs(d,:) = num_HVs(d-1,:);
        rand = randi(D,(D/M-d),1);
        for i = 1:length(rand)
            num_HVs(d,rand(i)) = ~num_HVs(d,rand(i));
        end
    end
    
    for p = 1:num_bins
        ID_HVs(p,:) = randi([0,1],1,1000);
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

    bin_max = -1;
    for i = 1:length(bin_values)
        if (abs(bin_values(i)) > bin_max)
            bin_max = abs(bin_values(i));
        end
    end
    
    for i = 1:length(bin_values)
        scaled_bins(i) = bin_values(i)/bin_max;
        scaled_bins(i) = floor(scaled_bins(i) * 10000)/10000;
    end
    
    for i = 1:length(scaled_bins)
        level_HVs(i,:) = BinEncoder(scaled_bins(i), digit_HVs);
    end
    
    audioHV = level_HVs(1,:) .* pos_HVs(1,:);
    for i = 2:length(level_HVs(1))
        audioHV = audioHV + level_HVs(i,:) .* pos_HVs(i,:);
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
        digit_rev(i) = mod(bin_digi,10);
        bin_digi = floor(bin_digi/10);
    end
    
    product = digit_HVs(digit_rev(5)+1,:);
    for i=4:-1:1
        product = product .* circshift(digit_HVs(fix(floor(digit_rev(i)+1)),:),5-i);
    end
    
    binHV = product;

end


function [class_HVs] = Train(HV_sets)
%% Training Function
% Takes HV_sets, a three-dimensional array that represents the full set of
%       all of the hypervectors, where each is a one-dimensional array, and
%       they are organized into two-dimensional arrays based on the class.
% 
% Returns class_HVs, a two-dimensional array of the trained class
%       hypervectors that are represented as one-dimensional arrays

    size(HV_sets,3);

    for i = 1:size(HV_sets,3)
        class_set = HV_sets(:,:,i);
        div_num = ((size(class_set,1) + 1)/2);
        
        for j = 1:size(class_set,2)
            col_sum = sum(class_set(:,j));
            class_HVs(i,j) = fix(abs(col_sum/div_num));
        end
    end

end