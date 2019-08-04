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

%% The Following Code is for an pass band filter bank with asymetric channel length %%%
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
%% Applying Bandpass Filters with Preassigned Bandpass Frequencies %%

fA = zeros(length(A),length(reMonoY));                    %Preallocating arrays
lpFilterA = zeros(length(A),length(reMonoY));

for i = 1:length(A)
     HA = Butter(A(i,1),A(i,2));
%     HA = Elliptic(A(i,1),A(i,2));
%     HA = Cheby(A(i,1),A(i,2));                                %Alternative FIR/IIR filters
%     HA = Cheby2(A(ii,1),A(i,2));
%     HA = Elliptic(A(ii,1),A(i,2));
%     HA = LeastSquaresOrder8(A(i,1),(A(i,1)+1),A(i,2),(A(i,2)+1));
%     HA = LeastSquaresOrder200(A(i,1),(A(i,1)+1),A(i,2),(A(i,2)+1));
    fA(i,:) = filter(HA,reMonoY);
    rectifyA = abs(fA(i,:));                         %Rectify the signal
    lpFilterA(i,:) = filter(LPButter400Hz,rectifyA); %Lowpass Filter Envelope
end 

TotalA = sum(fA);

%% Task 10: Cosine function that oscillates with the central frequency of each of the bandpass filters
centfreq = zeros(length(A),1); 

for i = 1:length(A)
    centfreq(i) = ((A(i,1)+A(i,2))/2);
    t = 0:1/FS:(length(lpFilterA(i,:)))/FS;
    x(i,:) = cos(2*pi*centfreq(i)*t);
    
end
 
%% Task 11:  amplitude modulate the cosine signal of Task 10 using the rectified signal of that channel

for i = 1:length(A)
      x2(i,:) = lpFilterA(i,:).*x(i,length(A(i,:)-1));
end

%% Task 12: Add all signals of Task 11 together. Normalize this signal by the maximum of its absolute value.

Output = sum(x2);
OutputNorm = abs(Output); %Normalize Signal
sound(OutputNorm,FS);  %Play Signal 


audiowrite('Asymmetric.wav',reMonoY,FS);
%% PLOTTING Cross Correlation

figure                                                  
[c,lag] = xcorr(reMonoY,Output,'coeff');  
plot(abs(lag),abs(c),'r');
title('Cross-Correlation for Upstream, Downstream')
xlabel('Lag')
ylabel('Cross-Correlation')

%% PLOTTING INPUT/PROCESSED Signals

%Plotting Asymmetric Bandpass Frequencies

figure                                                  
subplot(2,1,1)
plot (reMonoY,'r');
title('Original Signal')
xlabel('Sample Number')
ylabel('Relative Signal Magnitude')

subplot(2,1,2)
plot (OutputNorm,'r');
title('Processed Signal using Asymmetric Bandpass Frequencies')
xlabel('Sample Number')
ylabel('Relative Signal Magnitude')




