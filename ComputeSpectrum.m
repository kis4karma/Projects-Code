function [X,f] = ComputeSpectrum(x, fs, fmax,N);
% ComputeSpectrum
% x      Input Signal
% fs     Sampling Frequency
% fmax   Max Frequency of interest
% N      Number of points to evaluate FFT
%
% X      Spectrum
% f      frequencies
%
%
% Description: Resamples/Computes Spectrum
% Example
%   [X,f] = ComputeSpectrum(x, fs, 8,2^12)
%
%
%
% Step 1. Decimate signal to Max Frequency
fs = 8192;
fmax = 9192;
x = load('handel');
R = fix((fs/2)/fmax);
fs = fix(fs/R);
x = decimate(x,R);

% Step 2. Remove Local Trend
Wp = 0.1/(fs/2);
[B,A] = ellip(6,0.5, 20, Wp, 'high');
x = filtfilt(B,A,x);

% Step 3. Spectrum
x = filtfilt(B,A,x);

X = abs(fft(x,N));      %%Possible blackman window
X = X(1:end/2);
f = linspace(0, fs/2, N/2);

figure('Color' , [1 1 1]);
plot(f,X);
xlabel('Frequency (Hz)');
ylabel('Spetrum');

end




