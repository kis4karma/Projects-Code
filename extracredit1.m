%% Extra Credit
% by Sean Hanson
clear all

B=0
RunningtotalofFives=0
figure ('Color', [1 1 1])
while B < 100

RandomFiveorTen= rand(1,200);
NumberOfFives = RandomFiveorTen>.5;
NumberOfTens =  RandomFiveorTen <.5;
TotalFives=sum(NumberOfFives)
TotalTens=sum(NumberOfTens)

InitialFives=24

CashierFives= InitialFives + (TotalFives-TotalTens)

h= plot (B,CashierFives, '.');
xlabel('Random Numbers run')
ylabel('Total Count of Five Dollar Bills')
h= plot (B,CashierFives, '.')
set(h,'MarkerSize',18);
set(h,'Color',[1,.3,.3]);
axis([ 0 100 -50 50])
grid on;
hold on;
B=B+1

RunningtotalofFives = CashierFives + RunningtotalofFives



CountFivesUnderZero = 






end
AverageofCashierFives=RunningtotalofFives/100






