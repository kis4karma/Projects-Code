%%%USER INPUTS:%%%

%Sampled time-domain inputs:
fs=10E6; %Sampling frequency [Hz]
NF=2000; %Number of samples in simulation

%Transmitted signal:
fcarrier=.501E6; %Frequency of carrier wave [Hz]
phase_carrier=20; %Phase of reference signal [radians]
fm=.07E6; %frequency of message signal [Hz]

%BPF after squaring the input, centered at: 2*fcarrier
mult_filt_order=400 % order of filter
mult_filt_low_freq=.99E6; %pass band, lower bound
mult_filt_high_freq=1.01E6; %pass band, upper bound

%LPF that comes after downconvering multiplier
demod_filt_order=50 % order of filter
demod_filt_high_freq=.4E6; %pass band, upper bound

%AGC characeristics
ds=.2; %desired power at receiver
lenavg=300; %length over which to average
mu=.0015; %AGC algorithm stepsize

%PLL inputs:
fVCO=1E6; %free running oscilating frequency of VCO [Hz]
KVCO=.8E6; %Gain of VCO (i.e. voltage to frequency transfer coefficient) [Hz/V]
G1=0.4467; %Proportional gain term of PI controller
G2=1.7783e+05; %Integral gain term of PI controller
fc=.2E6; %Cut-off frequency of low-pass filter (after the multiplier) [Hz]
filter_coefficient_num=20; %Number of filter coefficeints of low-pass filter

%%%INITIALIZE%%%

%AGC initialization
a=zeros(size(1:NF)); a(1)=1; %initialize AGC amplitude parameter
s=zeros(size(1:NF)); %initialize outputs
avec=zeros(1,lenavg); %vector to store terms for averaging

%Sampled time-domain initialization
Ts=1/fs; %sampling period
t_vec=[0:Ts:(NF-1)*Ts]; %time vector

%Create transmitted signal
carrier=sin(2*pi*fcarrier*t_vec+phase_carrier*2*pi/360); %carrier_signal
message=.8*(sin(2*pi*fm*t_vec)+.2*sin(2*pi*fm*t_vec*2)+.1*sin(2*pi*fm*t_vec*3)); %message signal
modulated_carrier=carrier.*message; %product of carrier with message

%BPF initialization (filter after squarer)
b_mult_filt = fir1(mult_filt_order,[mult_filt_low_freq*2/fs mult_filt_high_freq*2/fs]); %design FIR filter coefficients
mult_filter_buffer=zeros(1,mult_filt_order+1);
squared_input_filtered=0;

%LPF initialization (filter after downconvering multiplier)
b_demod_filt = fir1(demod_filt_order,demod_filt_high_freq*2/fs, 'low'); %design FIR filter coefficients
demod_filter_buffer=zeros(1,demod_filt_order+1);
squared_input_filtered=0;

%PLL initialization
b = fir1(filter_coefficient_num,fc/(fs/2)); %design FIR filter coefficients
VCO=zeros(1,NF); %initialize VCO signal array
phi=zeros(1,NF); %initialize VCO angle (phi) array
error=zeros(1,NF); %initialize error array
Int_error=zeros(1,NF); %initialize error array
filter_buffer=zeros(1,filter_coefficient_num+1); %initialize PLL LPF buffer
error_mult=0; %initalize error signal

%%%BEGIN SAMPLED TIME SIMULATION!!!E%%%
for n=1:NF
    t=(n-1)*Ts; %Current time (start at t = 0 seconds
 
    %Extract carrier
    %1. Recieved signal sent to AGC to scale the amplitude
   
    s(n)=a(n)*modulated_carrier(n); %multiply AGC gain with the modulated carrier signal
    avec=[sign(a(n))*(s(n)^2-ds),avec(1:end-1)]; %incorporate new update into avec 
    a(n+1)=a(n)-mu*mean(avec); %update AGC gain 
    
    %2. Scaled recieved signal is  squared:
    squared_input(n)=s(n)^2; %Square the received signal
  
    %3. Scaled squared signal is processed by BPF to extract tone at 2*carrier
    mult_filter_buffer=[mult_filter_buffer(2:mult_filt_order+1), squared_input(n)]; %update BPF buffer
    squared_input_filtered(n+1)=fliplr(b_mult_filt)*mult_filter_buffer'; %BPF operation
    %reference(n)=squared_input_filtered(n); %this is the signal that goes to the PLL   
    
    %4. PLL calculations:
    error_mult(n)=squared_input_filtered(n)*VCO(n);%multiply VCO x Signal input to get raw error signal
    %Low pass filter the raw error signal:
    filter_buffer=[filter_buffer(2:filter_coefficient_num+1), error_mult(n)]; %update PLL LPF buffer
    error(n+1)=fliplr(b)*filter_buffer';
    %Process filtered error signal through PI controller:
    Int_error(n+1)=Int_error(n)+G2*error(n)*Ts;
    PI_error(n+1)=G1*error(n+1)+Int_error(n+1);
    %Update VCO:
    phi(n+1)=phi(n)+2*pi*PI_error(n+1)*KVCO*Ts; %update the phase of the VCO
    VCO(n+1)=sin(2*pi*fVCO*t+phi(n+1)); %compute VCO signal
    VCO_shifted(n+1)=sin(2*pi*fVCO*t+phi(n+1)-pi/2); %shift output of PLL by 90 degrees 
    
    %divide frequency of PLL's output by 2 AND subtract out the phase shift
    %caused by the BPF that was used to extract tone at 2*carrier. This
    %produces a tone that is syncronous with the carrier of the received signal.
    BPF_phase_shift=320; %This is experimentally found by looking at frequency response of BPF at center frequency
     Demod_sin(n)=sin((2*pi*fVCO*t+phi(n)-pi/2)/2-BPF_phase_shift*2*pi/360+0*pi); %1/2 frequency divider 
    
    %calculate actual carrier signal (we do this if to compare
    %with the tone we created above)
    Demod_sin_real(n)=sin(2*pi*fcarrier*t+phase_carrier*2*pi/360);
    
    %Take our found syncronous tone and multiply it with recieved signal to
    %down convert:
    demod_signal(n)=Demod_sin(n)*modulated_carrier(n); %multiply carrier with syncronous tone
    
    %LPF above signal to extract messae
    demod_filter_buffer=[demod_filter_buffer(2:demod_filt_order+1), demod_signal(n)]; %update filter buffer
    demod_input_filtered(n+1)=fliplr(b_demod_filt)*demod_filter_buffer'; %apply filter
    output(n)=2*demod_input_filtered(n); %multiply amplitude by 2 (just because). Finally, this is our (scaled) demodulated signal!
end

%plot transmitted signal
figure(1)
plot(t_vec, modulated_carrier, t_vec, message); %plot modulated signal
legend('Modulated carrier','Message','FontSize',12);
title('DSB-CS transmitted signal','FontSize',12)
xlabel('time [s]','FontSize',12)

%Plot VCO (output) and reference (input) signals:
figure(2)
plot(t_vec,squared_input_filtered(1:end-1),t_vec,VCO_shifted(1:end-1))
title('Plot of transmitted signal (squared and BPF and AGC) and output of VCO','FontSize',12)
xlabel('time [s]','FontSize',12)
legend('transmitted squared and filtered','Output of VCO')

%Plot error signal:
figure(3)
plot(t_vec,error(1:end-1))
title('PLL error signal','FontSize',12)
xlabel('time [s]','FontSize',12) 

%Plot original message and recovered message at output of receiver: 
figure(4)
plot(t_vec,message,t_vec,output)
title('Output of reciever','FontSize',12)
xlabel('time [s]','FontSize',12) 
legend('Original message','Recovered message at output of receiver')

%Plot actual carrier and extracted carrier (From PLL)
figure(5)
plot(t_vec,Demod_sin_real,t_vec,Demod_sin)
title('Extracted carrier','FontSize',12)
xlabel('time [s]','FontSize',12) 
legend('Actual carrier','Extracted carrier (from PLL) used to demodulate')

%Plot AGC gain
figure(6)
plot(t_vec,a(1:end-1))
title('AGC gain','FontSize',12)
xlabel('time [s]','FontSize',12) 