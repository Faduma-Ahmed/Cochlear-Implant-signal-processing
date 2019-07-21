function [reMonoY,samplesize] = Convertto16khz(filename)

[StereoY,RealFS] = audioread(filename);
samplesize = size(StereoY);
FS = 16000;

%%%%%%%%%%%% Convert to  Mono and then Resample%%%%%%%%%%%%%
if samplesize(1,2) > 1
    MonoY = sum(StereoY,2) / size(StereoY,2);
end

reMonoY = resample(MonoY,FS,RealFS);
samplesize = size(reMonoY);
    
%%%%%%%%%%%% Save Audio Files %%%%%%%%%%%%%
audiowrite('write1.wav',reMonoY,FS);

%%%%%%%%%%%% Graph %%%%%%%%%%
% 
% subplot(2,1,1);
% plot(MonoY)
% title('Original Signal')
% xlabel('Sample Number')
% ylabel('Relative Signal Magnitude')
% 
% subplot(2,1,2);
% plot(reMonoY)
% title('Processed Signal')
% xlabel('Sample Number')
% ylabel('Relative Signal Magnitude')

end

