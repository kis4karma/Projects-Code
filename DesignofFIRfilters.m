%% Design, Analysis, and Implementation of FIR filters
% by Sean Hanson

%% Part A: Designing and Analyzing Filters
% Design a 10th-order lowpass FIR filter using the window method to cut
% frequencies below 30Hz where the sampling frequency is 125 Hz

fs = 125;       % Sampling frequency
fc = 30;        % Cutoff Frequency
wc = fc/(fs/2); 
b=fir1(10, wc, 'low');
figure
stem(b);
figure
freqz(b,1,fs);

%% Design a 100th-order lowpass FIR filter using the window method.
% frequencies above 30Hz where the sampling frequency is 125 Hz will be
% cut.


fs = 125;       % Sampling frequency
fc = 30;        % Cutoff Frequency
wc = fc/(fs/2); 
b=fir1(100, wc, 'low');
figure
stem(b);
figure
freqz(b,1,fs);

%% Design a 10th-order highpass FIR filter using the window method  
% Frequencies below 30Hz where the sampling frequency is 125 Hz will be
% cut.


fs = 125;       % Sampling frequency
fc = 30;        % Cutoff Frequency
wc = fc/(fs/2); 
b5=fir1(10, wc, 'high');
figure
stem(b);
figure
freqz(b5,1,fs);


%% Design a 100th-order highpass FIR filter using the window method.
% Frequencies below 30Hz where the sampling frequency is 125 Hz


fs = 125;       % Sampling frequency
fc = 30;        % Cutoff Frequency
wc = fc/(fs/2); 
b6=fir1(100, wc, 'high');
figure
stem(b);
figure
freqz(b6,1,fs);

%% Comparing 10th order high pass with 100th order

figure
freqz(b5,1,fs);
hold on;
freqz(b6,1,fs);

%% Design a 100th-order bandpass FIR filter using the window method.
% Frequencies below 15 and above 30Hz will be cut.
% The sampling frequency is 125 Hz.
 


fs = 125;       % Sampling frequency
fclow= 15;        % low cutoff Frequency
fchigh = 30;    % high cutoff Frequency
wc1 = fclow/(fs/2); 
wc2 = fchigh/(fs/2);
b6=fir1(100,[ wc1 wc2], 'bandpass');
figure
stem(b);
figure
freqz(b6,1,fs);

%% Design a 100th-order bandstop FIR filter using the window method.
% Frequencies below 30Hz where the sampling frequency is 125 Hz will be
% cut.


fs = 125;       % Sampling frequency
fclow= 15;        % low cutoff Frequency
fchigh = 30;    % high cutoff Frequency
wc1 = fclow/(fs/2); 
wc2 = fchigh/(fs/2);
b6=fir1(100,[ wc1 wc2], 'stop');
figure
stem(b);
figure
freqz(b6,1,fs);


%% Design a 100th-order bandpass FIR filter using the window method (fir2). 
% Frequencies below 30Hz where the sampling frequency is 125 Hz will be
% cut.

f = [0 .3 .6 1]; 
fs = 125;       % Sampling frequency
m = [1 1 0 0 ];
      

b6=fir2(100,f,m);
figure
stem(b);
figure
freqz(b6,1,fs);

%% Lab Part B: Biomedical Signal Processing
% Lowpass Filter for quantization. This one was used to smooth out the signal. 

x = icp;
figure('Color', [1 1 1]);
t = ((0:length(x)-1)/fs);

h=plot(t,x);
xlabel('Time (s)');
ylabel('ICP');
hold on;
M = 5;
b= 1/M * ones(M,1);

y1 = filtfilt(b, 1, x); 
h = plot(t, y1);
set(h, 'Color', [1 .5 1]);
set(h,'Linewidth', 2); 


%% Design an FIR high-pass filter to eliminate low frequency trend. 
x = icp;
figure('Color', [1 1 1]);
t = ((0:length(x)-1)/fs);

h=plot(t,x);
xlabel('Time (s)');
ylabel('ICP');
M = 15;
b= 1/M * ones(M,1);
hold on;

y1 = filtfilt(b, 1, x); 
h = plot(t, y1);
set(h, 'Color', [0.5 0.5 1]);
set(h,'Linewidth', 2); 


%% Design an FIR high-pass filter to eliminate low frequency trend. 
x = icp;
figure('Color', [1 1 1]);
t = ((0:length(x)-1)/fs);

h=plot(t,x);
xlabel('Time (s)');
ylabel('ICP');
hold on;
M = 22;
b= 1/M * ones(M,1);

y1 = filter(b, 1, x); 
h = plot(t, y1);
set(h, 'Color', [1 0.5 1]);
set(h,'Linewidth', 2); 


%% Design to eliminate low frequency signal. 
% Output is close to a sinusoidal signal
x = icp;
figure('Color', [1 1 1]);
t = ((0:length(x)-1)/fs);

h= plot(t,x); 
xlabel('Time (s)');
ylabel('ICP');
hold on;
M = 30;
b= 1/M * ones(M,1);
 
y1 = filtfilt(b, 1, x); 
h = plot(t, y1);
set(h, 'Color', [0.5 0.5 1]);
set(h,'Linewidth', 2); 

%% Filter ECGNoisy60Hz. 
x = ecg;
figure('Color', [1 1 1]);
t = ((0:length(x)-1)/fs);

h= plot(t,x); 
xlabel('Time (s)');
ylabel('ECG');
hold on;
M = 10;
b= 1/M * ones(M,1);
 
y1 = filtfilt(b, 1, x); 
h = plot(t, y1);
set(h, 'Color', [0.5 0.5 1]);
set(h,'Linewidth', 2); 
%% Filter ECGQuanization. 
x = ecg;
figure('Color', [1 1 1]);
t = ((0:length(x)-1)/fs);

h= plot(t,x); 
xlabel('Time (s)');
ylabel('ECG');
hold on;
M = 3;
b= 1/M * ones(M,1);
 
y1 = filtfilt(b, 1, x); 
h = plot(t, y1);
set(h, 'Color', [0.5 0.5 1]);
set(h,'Linewidth', 2); 

%% Filter ECGNBaselineDrift.
x = ecg;
figure('Color', [1 1 1]);
t = ((0:length(x)-1)/fs);

h= plot(t,x); 
xlabel('Time (s)');
ylabel('ECG');
hold on;
M = 12;
b= 1/M * ones(M,1);
 
y1 = filtfilt(b, 1, x); 
h = plot(t, y1);
set(h, 'Color', [0.5 0.5 1]);
set(h,'Linewidth', 2); 

%% Filter ECGBaselinedCombined. 
x = ecg;
figure('Color', [1 1 1]);
t = ((0:length(x)-1)/fs);

h= plot(t,x); 
xlabel('Time (s)');
ylabel('ECG');
hold on;
M = 34;
b= 1/M * ones(M,1);
 
y1 = filtfilt(b, 1, x); 
h = plot(t, y1);
set(h, 'Color', [0.5 0.5 1]);
set(h,'Linewidth', 2); 

      %% Lab Part C: Speech Processing

      
      % Plotting my Speech. There is a continous signal that is being sampled 
      % 8000 times per second. Those samples are run through a processor
      % and stored as an int16. You can see the higher amplitudes when I am
      
      fss = 8000;
      t = ((0:length(r)-1)/fss);
      mySpeech = getaudiodata(r, 'int16');
      figure('Color', [1 1 1]);
      plot(mySpeech)
      xlabel('Time (s)');
      ylabel('Amplitude of Speech');
        
%% Design and apply 4 lowpass filters to the speech signal
 % At 3000 fc, my voice got lower
fs = 8000;       % Sampling frequency
fc = 3000;        % Cutoff Frequency
wc = fc/(fs/2); 
b1=fir1(200, wc, 'low');
y = mySpeech;
sound(double(y),fs)

%% Design and apply 4 lowpass filters to the speech signal
 % At 2500 fc, my voice is about the same but the background noise is lower
fs = 8000;       % Sampling frequency
fc = 2500;        % Cutoff Frequency
wc = fc/(fs/2); 
b1=fir1(200, wc, 'low');
y = mySpeech;
sound(double(y),fs)


%% Design and apply 4 lowpass filters to the speech signal
 % At 1000 fc, my voice sounds the same 
fs = 8000;       % Sampling frequency
fc = 1000;        % Cutoff Frequency
wc = fc/(fs/2); 
b1=fir1(200, wc, 'low');
y = mySpeech;
sound(double(y),fs)





%% Design and apply 4 high filters to the speech signal
 % At 100 fc, my voice sounds is getting cut off
fs = 8000;       % Sampling frequency
fc = 100;        % Cutoff Frequency
wc = fc/(fs/2); 
b1=fir1(200, wc, 'high');

y =mySpeech;
 
sound(double(y),fs)

%% Design and apply 4 high filters to the speech signal
 % At 500 fc, my voice sounds the same 
fs = 8000;       % Sampling frequency
fc = 500;        % Cutoff Frequency
wc = fc/(fs/2); 
b1=fir1(200, wc, 'high');

y =mySpeech;
 
sound(double(y),fs)

%% Design and apply 4 high filters to the speech signal
 % At 100 fc, my voice sounds the same 
fs = 8000;       % Sampling frequency
fc = 1000;        % Cutoff Frequency
wc = fc/(fs/2); 
b1=fir1(200, wc, 'high');
y =mySpeech;
 
sound(double(y),fs)

%% Design and apply 4 high filters to the speech signal
 % At 500 fc, my voice sounds the same 
fs = 8000;       % Sampling frequency
fc = 2000;        % Cutoff Frequency
wc = fc/(fs/2); 
b1=fir1(200, wc, 'high');

y =mySpeech;
 
sound(double(y),fs)



%% Lab Part D Audio Processing. The hardware is essentially doing the same
% thing with this audio. Its getting sampled at a certain rate and 
% then its being stored in a certain memort location.

load handel; 
b2 = fir1(200,[0.48 0.85]);
n2 = filtfilt(b2,1,randn(size(y)));
yn2 = y+n2; sound(yn2,Fs)

b2 = fir1(200,[1140 2780]/(Fs),'stop');

%% Design a bandpass filter ( min of 3 filters to boost or cut low 
% frequencies

 load handel; b2 = fir1(200,[0.1 0.2]);
 sound(y,Fs)
 b3 = fir1(400,[80 200]/(Fs/2),'stop');
 yf2 = filter(b3,1,yn2);

 %% Design a bandpass filter ( min of 3 filters to boost or cut low 
% frequencies

 load handel; b2 = fir1(200,[0.4 0.6]);
 sound(y,Fs)
 b3 = fir1(400,[300 800]/(Fs/2),'stop');
 y = filter(b3,1,yn2);
 
%% Design a bandpass filter ( min of 3 filters to boost or cut low 
% frequencies

 load handel; b2 = fir1(200,[0.7 0.9]);
 sound(y,Fs)
 b3 = fir1(400,[1200 2400]/(Fs/2),'stop');
 yf2 = filter(b3,1,yn2);
 
 %% Design an audio equilizer using fir2
 
    f = [0 0.48 0.48 1];            % Frequency breakpoints
    m = [0 0 1 1];                  % Magnitude breakpoints
    b = fir2(34,f,m);               % FIR filter design
    freqz(b,1,512);                 % Frequency response of filter
    output = filtfilt(b,1,y);       % Zero-phase digital filtering
 
 

 
 

      
      

        



