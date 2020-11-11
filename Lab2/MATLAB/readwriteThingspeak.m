%% write PI settings
channelID = 1206549;
writeKey = 'GK1CJHQPLEG61QB2';
readKey ='3VBA6UT33ZSX84YR';

temp = 23;
Kp = 1.5;
Ti = 13;
thingSpeakWrite(channelID,'Fields',[2,3,4],'Values',{temp, Kp, Ti},'WriteKey',writeKey)
%data = thingSpeakRead(channelID,'ReadKey',readKey,'Fields',[2,3,4],'NumPoints',1,'OutputFormat','TimeTable')