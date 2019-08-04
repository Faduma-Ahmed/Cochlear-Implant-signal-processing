# Cochlear-Implant-signal-processing
Design a rudimentary signal processor for cochlear implants, for course BME252 


### Phase 1: Preperation
1. Read sound files as its input signals, find sampling rate, convert to mono
2. Downsample audio 16 kHz <br/>
3. Generate a signal as cosine oscillating at 1 kHz 

### Phase 2: Filter Design
4. Design a bank of bandpass filters that filters the sound to N frequency bands between 100 Hz and 8 kHz.
   (Used asymetrical channel length to mimic basal membrane)
5. Pass through filters (IIR vs FIR), plot lowest & highest frequency channels
7. Rectify the output signals of all bandpass filters and detect the envelopes using lowpass filter (400 Hz)
8. Plot the envelope of the lowest and highest frequency channels

### Phase 3: Final product and Wrap up
9. Generate Cosine signal oscillating  with the central frequency of each of the bandpass filters and length of the rectified          signal
10. For each channel, amplitude modulate the cosine signal of Task 9 using the rectified signal of that
channel (Task 7)
11. Add  & normalize all signals


My teammates and I **varied the parameters of our signal processor by**:
- Comparing Equidistant, Overlapping and Asymmetric Channel lengths
- Use of IIR vs FIR filters 
- Changing cutoff of envelop detecting lowpass filter

We also calculated **cross correation** in order to visualize the lag between the input and output at each specific sample
