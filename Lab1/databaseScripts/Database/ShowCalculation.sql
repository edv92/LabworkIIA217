IF EXISTS (SELECT name
	FROM sysobjects
	WHERE name = 'ShowCalculation'
	AND type = 'V')
	DROP VIEW ShowCalculation
GO


CREATE VIEW ShowCalculation
AS

SELECT
SENSOR.SensorId,
CALCULATION.MeanCelcius,
CALCULATION.MaxCelcius,
CALCULATION.MinCelcius,
CALCULATION.MeanFahrenheit,
CALCULATION.MaxFahrenheit,
CALCULATION.MinFahrenheit

FROM CALCULATION
INNER JOIN SENSOR ON CALCULATION.SensorId = SENSOR.SensorId
