%% Plot temperature data
clear
clc
close all
% Access keys
cPIfignelID = 1206549;
writeKey = 'GK1CJHQPLEG61QB2';
readKey ='3VBA6UT33ZSX84YR';

%Read data
Temp_data = thingSpeakRead(cPIfignelID,'ReadKey',readKey,'Fields',[1],'Numminutes',100,'OutputFormat','TimeTable');
Setpoint_data = thingSpeakRead(cPIfignelID,'ReadKey',readKey,'Fields',[2],'Numminutes',100,'OutputFormat','TimeTable');
Kp_data = thingSpeakRead(cPIfignelID,'ReadKey',readKey,'Fields',[3],'Numminutes',100,'OutputFormat','TimeTable');
Ti_data = thingSpeakRead(cPIfignelID,'ReadKey',readKey,'Fields',[4],'Numminutes',100,'OutputFormat','TimeTable');
%Remove nan values
Temp_data = rmmissing(Temp_data);
Setpoint_data = rmmissing(Setpoint_data);
Kp_data = rmmissing(Kp_data);
Ti_data = rmmissing(Ti_data);

%plots
figure
plot(Temp_data.Timestamps,Temp_data.TemperatureC,'r')
hold on;
stairs(Setpoint_data.Timestamps,Setpoint_data.SetpointC,'b')
hold off;
title('Blackbox temperature data')
xlabel('Date and Time [MM.dd, hh:mm:ss]');
ylabel('Temperature[C]');
legend('airheater blackbox model','setpoint')

fig =figure
subplot(2,1,1)
stairs(Kp_data.Timestamps,Kp_data.Kp,'b')
title('Kp data');
subplot(2,1,2)
stairs(Ti_data.Timestamps,Ti_data.Ti,'b')
title('Ti data');

PIfig=axes(fig,'visible','off'); 
PIfig.Title.Visible='on';
PIfig.XLabel.Visible='on';
PIfig.YLabel.Visible='on';
xlabel(PIfig,'Date and Time [MM.dd, hh:mm:ss]');
ylabel(PIfig,'Parameter value');
