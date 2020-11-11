IF EXISTS (SELECT name
	FROM sysobjects
	WHERE name = 'SensorData'
	AND type = 'P')
	DROP PROCEDURE SensorData
GO


CREATE PROCEDURE SensorData
@Sensor varchar(10),
@Setpoint varchar(10),
@Celcius varchar(10),
@DateTime varchar(100)


AS

DECLARE

@SensorId int
SELECT CAST(@sensor AS INT);

SELECT @SensorId=SensorId from SENSOR where SensorId = @Sensor;

insert into TEMPERATURE_DATA(SensorId,Setpoint, CelciusData,  DateTime) values(@SensorId,@Setpoint, @Celcius, @DateTime)
GO