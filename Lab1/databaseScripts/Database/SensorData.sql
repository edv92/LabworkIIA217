IF EXISTS (SELECT name
	FROM sysobjects
	WHERE name = 'SensorData'
	AND type = 'P')
	DROP PROCEDURE SensorData
GO


CREATE PROCEDURE SensorData
@Sensor varchar(10),
@Celcius varchar(10),
@Fahrenheit varchar(10),
@DateTime varchar(100),
@SampleTime varchar(10)

AS

DECLARE

@SensorId int
SELECT CAST(@sensor AS INT);

SELECT @SensorId=SensorId from SENSOR where SensorId = @Sensor;

insert into TEMPERATURE_DATA(SensorId, CelciusData, FahrenheitData, DateTime,SampleTime) values(@SensorId, @Celcius, @Fahrenheit, @DateTime,@SampleTime)
GO