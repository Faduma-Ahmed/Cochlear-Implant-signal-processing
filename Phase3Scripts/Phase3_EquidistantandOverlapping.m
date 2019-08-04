clc; 
clear all; 
close all;

%% Add Required Paths %%
% addpath('Phase 1');
addpath('Random Test');
addpath('Lowpass400Hz');
addpath('FIR Filters Phase 2');
addpath('Sounds');

%% Call Audio File and Downsample/Mono %%
filename = ('twinkle.mp3');
[reMonoY,samplesize] = Convertto16khz(filename);
FS = 16000;

%% The Following Code is for an pass band filter bank with equidistant & overlapping channel lengths %%%
%% Predetermined Bandpass Filter Frequencies Arrays %%

TotalA = 0;
TotalB = 0;
A = [100 200;     %This is an array for a predetermined frequency        
     200 300;    %spectrum for each individual bandpass filter. n = 22 channels
     300 400;
     400 510;
     510 630;
     630 770;
     770 920;
     920 1080;
     1080 1270;
     1270 1480;
     1480 1720;
     1720 2000;
     2000 2320;
     2320 2700;
     2700 3150;
     3150 3700;
     3700 4400;
     4400 5300;
     5300 6400;
     6400 7700;
     7700 7998;
    ];
N = 22;            %Number of channels
B = [1,N];         %This array is the base where the equidistant bandpass filters are generated

fB = zeros(length(A),length(reMonoY));                    %Preallocating arrays
lpFilterB = zeros(length(A),length(reMonoY));
 
for iii = 1:21
        
    C(iii,1) = (iii)*(7900/N)-259;
    C(iii,2) = (iii+1)*(7900/N);                        %359 -> 69 if going from 22Ch to 120Ch then change 7900/120
%     HC = Elliptic(C(iii,1),C(iii,2));
    HC = LeastSquaresOrder8(C(iii,1),(C(iii,1)+1),C(iii,2),(C(iii,2)+1));
    fC(iii,:) = filter(HC,reMonoY);
    rectifyC = abs(fC(iii,:));                               %Rectify the signal
    lpFilterC(iii,:) = filter(LPButter550Hz,rectifyC);       %Lowpass Filter Envelope
                       
end


% sound(TotalC,FS);

%% Task 10: Cosine function that oscillates with the central frequency of each of the bandpass filters

centfreq = zeros(length(A),1); 

for i = 1:length(C)
    centfreq(i) = ((C(i,1)+C(i,2))/2);
    t = 0:1/FS:(length(lpFilterC(i,:)))/FS;
    xc(i,:) = cos(2*pi*centfreq(i)*t);
end  

%% Task 11:  amplitude modulate the cosine signal of Task 10 using the rectified signal of that channel

for i = 1:length(C)
      xc2(i,:) = lpFilterC(i,:).*xc(i,length(C(i,:)-1));
end

%% Task 12: Add all signals of Task 11 together. Normalize this signal by the maximum of its absolute value.

OutputC = sum(xc2);
OutputNormC = abs(OutputC);
sound(OutputNormC,FS);  %Play Signal  

audiowrite('Least8th_FinalOutput.wav',reMonoY,FS);
%% PLOTTING Cross Correlation

figure                                                  
[c,lag] = xcorr(reMonoY,OutputC,'coeff');  
plot(abs(lag),abs(c), 'r');
title('Cross-Correlation for Upstream, Downstream')
xlabel('Lag')
ylabel('Cross-Correlation')

%% PLOTTING INPUT/PROCESSED Signals

%Plotting Equidistant Bandpass Frequencies

figure                                                  
subplot(2,1,1)
plot (reMonoY,'r');
title('Original Signal')
xlabel('Sample Number')
ylabel('Relative Signal Magnitude')

subplot(2,1,2)
plot (OutputNormC,'r');
title('Processed Signal using Equidistant & Overlapping Bandpass Frequencies')
xlabel('Sample Number')
ylabel('Relative Signal Magnitude')







