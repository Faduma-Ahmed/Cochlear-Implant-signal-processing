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

%% The Following Code is for an pass band filter bank with equidistant channel lengths %%%
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
 
for ii = 1:8
    
    B(ii,1) = 100 + (ii-1)*(7900/10);
    B(ii,2) = (7900/10)  + (ii-1)*(7900/10);                    %359 -> 69 if going from 22Ch to 120Ch then change 7900/120
    HB = Butter(B(ii,1),B(ii,2));
%     HB = Cheby(B(ii,1),B(ii,2));                                %Alternative FIR/IIR filters
%     HB = Cheby2(B(ii,1),B(ii,2));
%     HB = Elliptic(B(ii,1),B(ii,2));
%     HB = LeastSquaresOrder8(B(ii,1),(B(ii,1)+1),B(ii,2),(B(ii,2)+1));
%     HB = LeastSquaresOrder200(B(ii,1),(B(ii,1)+1),B(ii,2),(B(ii,2)+1));
    fB(ii,:) = filter(HB,reMonoY);
    rectifyB = abs(fB(ii,:));                               %Rectify the signal
    lpFilterB(ii,:) = filter(LPButter550Hz,rectifyB);       %Lowpass Filter Envelope
    TotalB = sum(fB);                                       %Recombines all bandpass filters again (not used)
end

% sound(TotalB,FS);

%% Task 10: Cosine function that oscillates with the central frequency of each of the bandpass filters

centfreq = zeros(length(A),1); 

for i = 1:length(B)
    centfreq(i) = ((B(i,1)+B(i,2))/2);
    t = 0:1/FS:(length(lpFilterB(i,:)))/FS;
    xb(i,:) = cos(2*pi*centfreq(i)*t);
end 

%% Task 11:  amplitude modulate the cosine signal of Task 10 using the rectified signal of that channel

for i = 1:length(B)
      xb2(i,:) = lpFilterB(i,:).*xb(i,length(B(i,:)-1));
end

%% Task 12: Add all signals of Task 11 together. Normalize this signal by the maximum of its absolute value.

OutputB = sum(xb2);
OutputNormB = abs(OutputB);
sound(OutputNormB,FS);  %Play Signal 

audiowrite('Equidistant.wav',reMonoY,FS);
%% PLOTTING Cross Correlation

figure                                                  
[c,lag] = xcorr(reMonoY,OutputB,'coeff');  
plot(abs(lag),abs(c));
plot(abs(lag),abs(c),'b');
title('Cross-Correlation for Upstream, Downstream')
xlabel('Lag')
ylabel('Cross-Correlation')

%% PLOTTING INPUT/PROCESSED Signals

%Plotting Equidistant Bandpass Frequencies

figure                                                  
subplot(2,1,1)
plot (reMonoY,'b');
title('Original Signal')
xlabel('Sample Number')
ylabel('Relative Signal Magnitude')

subplot(2,1,2)
plot (OutputNormB,'b');
title('Processed Signal using Equidistant Bandpass Frequencies')
xlabel('Sample Number')
ylabel('Relative Signal Magnitude')







