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

