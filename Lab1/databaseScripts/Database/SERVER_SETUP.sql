--SERVER SETUP--

--CREATE TABLES--
IF EXISTS (SELECT name
	FROM sysobjects
	WHERE name = 'TEMPERATURE_DATA'
	AND type = 'U')
	ALTER TABLE TEMPERATURE_DATA
	DROP CONSTRAINT FK_SENSORTEMPT; 
GO

IF EXISTS (SELECT name
	FROM sysobjects
	WHERE name = 'CALCULATION'
	AND type = 'U')
	ALTER TABLE CALCULATION
	DROP CONSTRAINT FK_SENSORCALC; 
GO
IF EXISTS (SELECT name
	FROM sysobjects
	WHERE name = 'SENSOR'
	AND type = 'U')
	ALTER TABLE SENSOR
	DROP CONSTRAINT XPKSENSOR; 
GO






IF EXISTS (SELECT name
	FROM sysobjects
	WHERE name = 'SENSOR'
	AND type = 'U')
	DROP TABLE SENSOR;
GO
IF EXISTS (SELECT name
	FROM sysobjects
	WHERE name = 'TEMPERATURE_DATA'
	AND type = 'U')
	DROP TABLE TEMPERATURE_DATA;
GO

IF EXISTS (SELECT name
	FROM sysobjects
	WHERE name = 'CALCULATION'
	AND type = 'U')
	DROP TABLE CALCULATION;
GO

CREATE TABLE [SENSOR]
(
	[SensorId] integer NOT NULL,
	[SensorName] varchar(50) NULL,
	[SensorType] varchar(30) NULL
)
go
ALTER TABLE [SENSOR]
	ADD CONSTRAINT [XPKSENSOR] PRIMARY KEY  CLUSTERED ([SensorId] ASC)
go

CREATE TABLE [CALCULATION]
( 
	[CalculationId]     integer NOT NULL ,
	[MeanCelcius]    decimal(5,2)  NULL ,
	[MaxCelcius]    decimal(5,2)  NULL ,
	[MinCelcius]    decimal(5,2)  NULL ,
	[MeanFahrenheit]    decimal(5,2)  NULL ,
	[MaxFahrenheit]    decimal(5,2)  NULL ,
	[MinFahrenheit]    decimal(5,2)  NULL ,
	[SensorId]           integer  NULL 
)
go

ALTER TABLE [CALCULATION]
	ADD CONSTRAINT [XPKCALCULATION] PRIMARY KEY  CLUSTERED ([CalculationId] ASC)
go

CREATE TABLE [TEMPERATURE_DATA]
( 
	[SampleId] integer IDENTITY(1,1),
	[SensorId]        integer  NULL ,
	[CelciusData]    float  NULL ,
	[FahrenheitData]    float  NULL ,
	[Setpoint] float NULL,
	[SetpointFahrenheit] decimal(5,2),
	[DateTime]          varchar(50)  NULL ,
)
go

ALTER TABLE [TEMPERATURE_DATA]
	ADD CONSTRAINT [XPKTEMPERATURE_DATA] PRIMARY KEY  CLUSTERED ([SampleId] ASC)
go


ALTER TABLE [CALCULATION]
	ADD CONSTRAINT [FK_SENSORCALC] FOREIGN KEY ([SensorId]) REFERENCES [SENSOR]([SensorId])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go
ALTER TABLE [TEMPERATURE_DATA]
	ADD CONSTRAINT [FK_SENSORTEMPT] FOREIGN KEY ([SensorId]) REFERENCES [SENSOR]([SensorId])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

-- STORE PROCEDURE--
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

--CALCULATION TRIGGER--
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
@SampleId int,
@AverageCelcius decimal(5,2),
@MinimumCelcius decimal(5,2),
@MaximumCelcius decimal(5,2),
@Fahrenheit decimal(5,2),
@AverageFahrenheit decimal(5,2),
@MinimumFahrenheit decimal(5,2),
@MaximumFahrenheit decimal(5,2),
@SetpointFahrenheit decimal(5,2)


SELECT @SensorId = SensorId from INSERTED
SELECT @SampleId = SampleId from INSERTED
SELECT @AverageCelcius = AVG(CelciusData) FROM TEMPERATURE_DATA WHERE SensorId = @SensorId
SELECT @MaximumCelcius = MAX(CelciusData) FROM TEMPERATURE_DATA WHERE SensorId = @SensorId
SELECT @MinimumCelcius = MIN(CelciusData) FROM TEMPERATURE_DATA WHERE SensorId = @SensorId

SELECT @AverageFahrenheit = AVG(FahrenheitData) FROM TEMPERATURE_DATA WHERE SensorId = @SensorId
SELECT @MaximumFahrenheit = MAX(FahrenheitData) FROM TEMPERATURE_DATA WHERE SensorId = @SensorId
SELECT @MinimumFahrenheit = MIN(FahrenheitData) FROM TEMPERATURE_DATA WHERE SensorId = @SensorId
SELECT @Fahrenheit = 9*(CelciusData)/5+32 FROM TEMPERATURE_DATA WHERE SampleId = @SampleId
SELECT @SetpointFahrenheit = 9*(Setpoint)/5+32 FROM TEMPERATURE_DATA  WHERE SampleId = @SampleId

UPDATE CALCULATION SET
MeanCelcius = @AverageCelcius,
MaxCelcius = @MaximumCelcius,
MinCelcius = @MinimumCelcius,
MeanFahrenheit = @AverageFahrenheit,
MaxFahrenheit = @MaximumFahrenheit,
MinFahrenheit = @MinimumFahrenheit

Where SensorId = @SensorId

UPDATE TEMPERATURE_DATA set
FahrenheitData = @Fahrenheit,
SetpointFahrenheit = @SetpointFahrenheit
Where SampleId = @SampleId



GO
--VIEWS--
IF EXISTS (SELECT name
	FROM sysobjects
	WHERE name = 'ShowSensorData'
	AND type = 'V')
	DROP VIEW ShowSensorData
GO


CREATE VIEW ShowSensorData
AS

SELECT
SENSOR.SensorId,
SENSOR.SensorName,
TEMPERATURE_DATA.SampleId,
TEMPERATURE_DATA.Setpoint,
TEMPERATURE_DATA.SetpointFahrenheit,
TEMPERATURE_DATA.CelciusData,
TEMPERATURE_DATA.FahrenheitData,
TEMPERATURE_DATA.DateTime

FROM TEMPERATURE_DATA
INNER JOIN SENSOR ON TEMPERATURE_DATA.SensorId = SENSOR.SensorId



GO

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
GO

--INITIALIZE SCRIPT-
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