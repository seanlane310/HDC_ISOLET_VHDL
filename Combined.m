clc; clear all; close all;

r = audiorecorder(44100,16,1);
record(r);
fprintf("1");
pause(2);
stop(r);
y = getaudiodata(r,'double');

%% Do Processing
plot(y);

pause(5);

N = 0:length(y)-1;

X = fft(y); %need to trim it before get here
plot(abs(X(1:length(X)/16)));

Z = abs(X);

total = length(1:length(X)/16);
bins = 100;

binsize = total/bins;

for i = 1:bins
        average(i) = mean(Z((i*binsize)+1:((i+1)*binsize)));
end

fprintf("done");

plot(average);

%% Project Frequency Bins onto Hypervectors
BaseVectors(1,:) = randi([0,1],1,1000);
%BaseVectors(1,BaseVectors(1,:) == 0) = -1;

BaseVectors(2,:) = randi([0,1],1,1000);
%BaseVectors(2, BaseVectors(2,:) == 0) = -1;

BaseVectors(3,:) = randi([0,1],1,1000);
%BaseVectors(3,BaseVectors(3,:) == 0) = -1;

BaseVectors(4,:) = randi([0,1],1,1000);
%BaseVectors(4, BaseVectors(4,:) == 0) = -1;

BaseVectors(5,:) = randi([0,1],1,1000);
%BaseVectors(5, BaseVectors(5,:) == 0) = -1;

BaseVectors(6,:) = randi([0,1],1,1000);
%BaseVectors(6, BaseVectors(6,:) == 0) = -1;

BaseVectors(7,:) = randi([0,1],1,1000);
%BaseVectors(7, BaseVectors(7,:) == 0) = -1;

BaseVectors(8,:) = randi([0,1],1,1000);
%BaseVectors(8, BaseVectors(8,:) == 0) = -1;

BaseVectors(9,:) = randi([0,1],1,1000);
%BaseVectors(9, BaseVectors(9,:) == 0) = -1;

BaseVectors(10,:) = randi([0,1],1,1000);
%BaseVectors(10, BaseVectors(10,:) == 0) = -1;

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