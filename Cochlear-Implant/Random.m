clc; close all; clear all;

addpath('Random Test');
addpath('Lowpass400Hz');

filename = ('Sample2.mp3');
[reMonoY,samplesize] = Convertto16khz(filename);

%%%% Cosine Plot %%%%%
FS = 16000;
Freq = 1000;                         %in Hz
dt = 1/Freq;
t = 0:(1/FS):(samplesize(1:1)/FS);
x = cos(2*pi*100*t);

A= [ 1 100;
    100 200;
    200 300;
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

Total=0;
B = [1,10];

% 
% for ii = 1:length(B)
%     
%     B(ii,1) = 1 + (ii-1)*(7900/22);
%     B(ii,2) = 359 + (ii-1)*(7900/22);
%     H=Cheby(B(ii,1),B(ii,2));
%     f= filter(H,reMonoY);
%     Total= Total+ f;
% 
% end

% H = Butter(A(3,1),A(3,2));
% f = filter(H,reMonoY);
% lpFilter = filter(LPButter400Hz,f);

for i=1:length(A)
    H=Butter(A(i,1),A(i,2));
    f= filter(H,reMonoY);
    lpFilter = filter(LPButter400Hz,f);
    Total = Total + lpFilter;
end

sound(Total,16000);

% plot(f);
% hold on;
% task7 = hilbert(f);
% env = abs(task7);
% plot(env);

% figure
% plot(t,x)
% xlim([0 2/Freq]);
% title('Cosine Function');
% xlabel('Time (s)');
% ylabel('Relative Amplitude');
% sound(x,FS)

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% addpath('Butterworth1');
%     Hd1 = RandomButter1;
%     Hd2 = RandomButter2;
%     Hd3 = RandomButter3;
%     Hd4 = RandomButter4;
%     Hd5 = RandomButter5;
%     Hd6 = RandomButter6;
%     Hd7 = RandomButter7;
%     Hd8 = RandomButter8;
%     Hd9 = RandomButter9;
%     Hd10 = RandomButter10;
%     Hd11 = RandomButter11;
%     Hd12 = RandomButter12;
%     Hd13 = RandomButter13;
%     Hd14 = RandomButter14;
%     Hd15 = RandomButter15;
%     Hd16 = RandomButter16;
%     Hd17 = RandomButter17;
%     Hd18 = RandomButter18;
%     Hd19 = RandomButter19;
%     Hd20 = RandomButter20;
%     Hd21 = RandomButter21;
%     Hd22 = RandomButter22;
%     
% f10 = filter(Hd10,reMonoY);
% f11 = filter(Hd11,reMonoY);
% f12 = filter(Hd12,reMonoY);
% f13 = filter(Hd13,reMonoY);
% f14 = filter(Hd14,reMonoY);
%     
% Total = f10 + f11 + f12 + f13 + f14;
% sound(Total,16000);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
