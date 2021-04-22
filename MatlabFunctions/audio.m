%Audio Record
r = audiorecorder(44100,16,1);
record(r);
fprintf("1");
pause(2);
stop(r);
y = getaudiodata(r,'double');
