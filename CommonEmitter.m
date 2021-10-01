% Common Emitter Amplifier with voltage divider bias
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Re = 2500; % emitter resistance in ohms
R1 = 120000; % voltage divider resistance R1 in ohms
R2 = 20000; % voltage divider resistance R2 in ohms
hFE = 150; % DC current gain
Rc = 7500; % collector resistance in ohms
Vcc = 12; % DC power supply voltage in volts
fprintf('********** Common Emitter Amplifier ***********\n');
fprintf(' Given Parameters \n');
fprintf(' ****************\n')
fprintf(' Resistor R1 = %d ohms\n', R1);
fprintf(' Resistor R2 = %d ohms\n', R2);
fprintf(' Collector Resistor = %d ohms\n', Rc);
fprintf(' Emitter Resistor = %d ohms\n', Re);
fprintf('************************************************\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DC Analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set up matrix equation
 R = [-(hFE+1)*Re R2+(hFE+1)*Re; R1 R2];
V = [0.7
 Vcc];
% Solve matrix equation
I = R\V ;
I1 = I(1); % current in resistor R1
I2 = I(2); % current in resistor R2
% Compute transistor currents and voltages
Ib = I1 - I2; % base current
Ic = Ib; % collector current
Ie = Ib+Ic; % emitter current
Ve = Ie*Re; % emitter voltage
Vb =Ve+0.7; % base voltage
Vc = Vcc - Ic*Rc; % collector voltage
VbUnloaded = Vcc*R2/(R1+R2); % base voltage with BJT removed
% results
fprintf('\n******* DC Analysis Results **********\n');
fprintf(' Base Voltage = %.2f volts\n', Vb);
fprintf(' Unloaded Base Voltage = %.2f volts\n', VbUnloaded);
fprintf(' Collector Voltage = %.2f volts\n', Vc);
fprintf(' Emitter Voltage = %.2f volts\n', Ve);
fprintf(' Base Current = %.2f uA\n', Ib*1e6);
fprintf(' Collector Current = %.2f mA\n', Ic*1000);
fprintf(' Emitter Current = %.2f mA\n', Ie*1000);
fprintf('******************************************\n');