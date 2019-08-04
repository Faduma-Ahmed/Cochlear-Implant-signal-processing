clc; close all; clear all;
filename = ('Sample2.mp3');
[reMonoY,samplesize] = Convertto16khz(filename);

FS = 16000;
Freq = 1000;                         %in Hz
dt = 1/Freq;
t = 0:(1/FS):(samplesize(1:1)/FS);
x = cos(2*pi*1000*t);

figure
plot(t,x)
xlim([0 2/Freq]);
title('Cosine Function');
xlabel('Time (s)');
ylabel('Relative Amplitude');