IF EXISTS (SELECT name
	FROM sysobjects
	WHERE name = 'getSensorStats'
	AND type = 'TR')
	DROP TRIGGER getSensorStats
GO


CREATE TRIGGER getSensorStats ON TEMPERATURE_DATA
FOR UPDATE, INSERT, DELETE
AS

DECLARE
@SensorId int,
@AverageCelcius decimal(5,2),
@MinimumCelcius decimal(5,2),
@MaximumCelcius decimal(5,2),
@AverageFahrenheit decimal(5,2),
@MinimumFahrenheit decimal(5,2),
@MaximumFahrenheit decimal(5,2)


SELECT @SensorId = SensorId from INSERTED

SELECT @AverageCelcius = AVG(CelciusData) FROM TEMPERATURE_DATA WHERE SensorId = @SensorId
SELECT @MaximumCelcius = MAX(CelciusData) FROM TEMPERATURE_DATA WHERE SensorId = @SensorId
SELECT @MinimumCelcius = MIN(CelciusData) FROM TEMPERATURE_DATA WHERE SensorId = @SensorId

SELECT @AverageFahrenheit = AVG(FahrenheitData) FROM TEMPERATURE_DATA WHERE SensorId = @SensorId
SELECT @MaximumFahrenheit = MAX(FahrenheitData) FROM TEMPERATURE_DATA WHERE SensorId = @SensorId
SELECT @MinimumFahrenheit = MIN(FahrenheitData) FROM TEMPERATURE_DATA WHERE SensorId = @SensorId

UPDATE CALCULATION SET
MeanCelcius = @AverageCelcius,
MaxCelcius = @MaximumCelcius,
MinCelcius = @MinimumCelcius,
MeanFahrenheit = @AverageFahrenheit,
MaxFahrenheit = @MaximumFahrenheit,
MinFahrenheit = @MinimumFahrenheit

Where SensorId = @SensorId


GO
