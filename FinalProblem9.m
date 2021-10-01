%% A student wants to visualize the spectrum of the following CT signal using MATLAB, 
%% x(t) = cos(2*pi*2*t); t in seconds He computes a 1024-point FFT of 100 samples using a 
%% sampling frequency of 200 Hz. Which of the following recommendations would you give him?


fs = 8; % Sampling Frequency
T = 1/fs; % Sampling Period
n =0:.008*fs;% Plot 100 seconds
k = n*T; % Time Index
xs = cos(2*pi*2*k);
figure('Color', [ 1 1 1]);
h = plot(k,xs); set(h, 'Markersize', 15);
ylabel('x(nT)'); box off;
axis tight;

w = window(@blackman ,length(n));  % Window length
figure('Color', [1 1 1]);
h = plot(w);

x = xs.*w';
figure('Color', [1 1 1]);
h = plot(x,w);

N= 2^12;
X = abs(fft(x,N));
X = X(1:end/2);
f= linspace(0, fs/2,length(X));

figure('Color', [1 1 1]);
plot(f,X)
figure('Color', [ 1 1 1]);
X = abs(fft(xs)); % FFT Magnitude
f = (1:length(X))*fs/length(X);% Frequency axis
stem(f(1:end/2),X(1:length(X)/2)); box off; axis tight;

% I can see the effect of the window because it is filtering out some of
% the sine wave