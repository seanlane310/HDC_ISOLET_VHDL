%Save Audio Sets to load into training/encoding

% Set global variables
classes = 6; %      Number of different letters being used
records = 1; %     Number of audio samples to be recorded
bins = 1000; %      Number of sections audio is split into

for i = 1:classes
    audio_sets(:,:,i) = RecordAudio(records);
end

function [audioData] = RecordAudio(num_takes)
%% Audio Recording
% Records 2 seconds of audio a number of times.
%
% Takes num_takes, the number of audio recordings taken.
%
% Returns audioData, an array of the audio recordings.

    for audioid = 1:num_takes
        r(audioid) = audiorecorder(44100,16,1);
        record(r(audioid));
        fprintf("%i\n",audioid);
        pause(2);
        fprintf("stop\n");
        pause(0.5);
        stop(r(audioid));
        x = getaudiodata(r(audioid),'double');
        y(:,audioid) = x(1:87040);
        pause(1.5);
    end
    
    audioData = y;
end