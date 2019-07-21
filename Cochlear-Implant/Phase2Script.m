clc; clear all; close all;

%% Add Required Paths %%
addpath('Random Test');
addpath('Lowpass400Hz');

%% Call Audio File and Downsample/Mono %%
filename = ('Sample2.mp3');
[reMonoY,samplesize] = Convertto16khz(filename);
FS = 16000;

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
     7700 7999;
    ];
N = 22;            %Number of channels
B = [1,N];         %This array is the base where the equidistant bandpass filters are generated

%% Applying Bandpass Filters with Preassigned Bandpass Frequencies %%

fA = zeros(length(A),length(reMonoY));                    %Preallocating arrays
lpFilterA = zeros(length(A),length(reMonoY));

for i = 1:length(A)
    HA = Butter(A(i,1),A(i,2));
    fA(i,:) = filter(HA,reMonoY);
    rectifyA = abs(fA(i,:));                         %Rectify the signal
    lpFilterA(i,:) = filter(LPButter400Hz,rectifyA); %Lowpass Filter Envelope
    TotalA = sum(fA);                                %Recombines all bandpasses together again (not used)
    
    
%     subplot(length(A),1,2)
%     plot(TotalA);                                    %Plots the original sound file
%     subplot(length(A)+2,1,i+2)                       %Plots all the channels
%     plot(fA(i,:))
end                  

sound(TotalA,FS);
% 
figure                              %Plot of Lowest & Highest Channels
subplot(2,1,1)
plot(fA(1,:));               
title('Lowest Bandpass Frequency Channel with Freq. Range 100-200Hz');
xlabel('Sample Number');
ylabel('Relative Intensity');

subplot(2,1,2)
plot(fA(length(A),:));       
title('Highest Bandpass Frequency Channel with Freq. Range 7700-7999Hz');
xlabel('Sample Number');
ylabel('Relative Intensity');

figure                              %Plot of Envelope of Lowest & Highest Channels
subplot(2,1,1)
plot(lpFilterA(1,:));
title('Envelope of Lowest Frequency Channel with Freq. Range 100-200Hz');
xlabel('Sample Number');
ylabel('Absolute Intensity');

subplot(2,1,2)
plot(lpFilterA(length(A),:));
title('Envelope of Highest Frequency Channel with Freq. Range 7700-7999Hz');
xlabel('Sample Number');
ylabel('Absolute Intensity');

%% Applying Bandpass Filters with Equadistant Bandpass Frequencies %%

fB = zeros(length(A),length(reMonoY));                    %Preallocating arrays
lpFilterB = zeros(length(A),length(reMonoY));

for ii = 1:N
    
    B(ii,1) = 100 + (ii-1)*(7900/N);
    B(ii,2) = (7900/N)  + (ii-1)*(7900/N);                    %359 -> 69 if going from 22Ch to 120Ch then change 7900/120
    HB = Butter(B(ii,1),B(ii,2));
    fB(ii,:) = filter(HB,reMonoY);
    rectifyB = abs(fB(ii,:));                               %Rectify the signal
    lpFilterB(ii,:) = filter(LPButter400Hz,rectifyB);       %Lowpass Filter Envelope
    TotalB = sum(fB);                                       %Recombines all bandpass filters again (not used)
end

sound(TotalB,FS);

figure                                                  %Plot of Lowest & Highest Channels
subplot(2,1,1)          
plot(fB(1,:));
title('Lowest Bandpass Filter of Frequency Range 1-359Hz');
xlabel('Sample Number');
ylabel('Relative Intensity');

subplot(2,1,2);
plot(fB(N,:));
title('Highest Bandpass Filter of Frequency Range 7541-7899Hz');
xlabel('Sample Number');
ylabel('Relative Intensity');

figure                                                  %Plot of Envelope of Lowest & Highest Channels
subplot(2,1,1)
plot(lpFilterB(1,:));
title('Envelope of Lowest Frequency Channel with Freq. Range 1-359Hz');
xlabel('Sample Number');
ylabel('Absolute Intensity');

subplot(2,1,2)
plot(lpFilterB(N,:));
title('Envelope of Highest Frequency Channel with Freq. Range 7541-7899Hz');
xlabel('Sample Number');
ylabel('Absolute Intensity');
