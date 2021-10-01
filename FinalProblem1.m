 %% Consider the following MATLAB code using the handel.mat example file that comes with MATLAB: >> load handel; 
 % >> ys = y(1000:1000+Fs); >> [X,f] = SpectrumAnalysis(ys,Fs,2^12); 
 % where SpectrumAnalysis is a user defined function that computes an N-point 
 % FFT (i.e. 2^12 points), to an input signal ys with a sampling frequency Fs. 
  % Which of the following statements about the spectrum of ys is correct?


load handel; 

ys = y(1000:1000+Fs); 
[X,f] = FFT(ys,Fs,2^12);