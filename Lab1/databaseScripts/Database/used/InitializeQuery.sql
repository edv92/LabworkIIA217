IF EXISTS (SELECT name
	FROM sysobjects
	WHERE name = 'SENSOR'
	AND type = 'U')
	DELETE FROM SENSOR;
GO
IF EXISTS (SELECT name
	FROM sysobjects
	WHERE name = 'TEMPERATURE_DATA'
	AND type = 'U')
	DELETE FROM TEMPERATURE_DATA;
GO

IF EXISTS (SELECT name
	FROM sysobjects
	WHERE name = 'CALCULATION'
	AND type = 'U')
	DELETE FROM CALCULATION;
GO

insert into SENSOR(SensorId, SensorName, SensorType) values(1,'TC-01','RTD')
insert into CALCULATION(CalculationId,SensorId, MeanCelcius, MaxCelcius, MinCelcius, MeanFahrenheit, MaxFahrenheit, MinFahrenheit) values (1,1,0,0,0,0,0,0)