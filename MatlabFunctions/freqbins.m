%% Create Frequency Bins
plot(y); %Plotting Data

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
