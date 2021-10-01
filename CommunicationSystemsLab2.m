%% Solo Matlab Lab # 2-- Using AGC and PLL's
% by Sean Hanson
% Communication Systems


f0=1;     %center frequency of input sinusoid 1 HZ
fs=20; %sample frequency of 20
dt = 1/fs;                   % seconds per sample
StopTime = 500;             % seconds
t = (0:dt:StopTime-dt)';     % seconds

input_signal=sin(f0*2*pi*t);
lenavg = 100;       % change back to 100
mu = .001;          % change back to .001
output_power = .1;  % change back to .1

n=length(input_signal); %find length of input signal
a=zeros(1,n); a(1)=1;%initialize AGC parameter
s=zeros(1,n); %initialize outputs
avec=zeros(1,lenavg); %vector to store averaging terms
for k=1:n-1
    s(k)=a(k)*input_signal(k); %normalize by a(k) and add to avec
    avec=[sign(a(k))*(s(k)^2-output_power), avec(1:lenavg-1)];
    a(k+1)=a(k)-mu*mean(avec); %average adaptive update of a(k)
end
% AGC being applied twice
output_signal=s;
h = figure;
plot(t,output_signal);
xlabel('Time (s)'); ylabel ('Output Signal');
 
input_signalA = output_signal;

lenavgA = 100;       % change back to 100
muA = .001;          % change back to .001
output_powerA = .1;  % change back to .1

nA=length(input_signalA); %find length of input signal
aA=zeros(1,nA); aA(1)=1;%initialize AGC parameter
sA=zeros(1,nA); %initialize outputs
avecA=zeros(1,lenavgA); %vector to store averaging terms
for kA=1:nA-1
    sA(kA)=aA(kA)*input_signalA(kA); %normalize by a(k) and add to avec
    avecA=[sign(aA(kA))*(sA(kA)^2-output_powerA), avecA(1:lenavgA-1)];
    aA(kA+1)=aA(kA)-muA*mean(avecA); %average adaptive update of a(k)
end
output_signalA=sA;
 figure;
plot(t,output_signalA);
xlabel('Time (s)'); ylabel ('Output Signal through AGC twice');

 