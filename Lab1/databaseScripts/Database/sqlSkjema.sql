
CREATE TABLE [DATALOG]
( 
	[DataLogId]          integer  NOT NULL ,
	[TemperatureData]    float  NULL ,
	[TimeStamp]          datetime  NULL ,
	[SensorId]           integer  NULL 
)
go

ALTER TABLE [DATALOG]
	ADD CONSTRAINT [XPKDATALOG] PRIMARY KEY  CLUSTERED ([DataLogId] ASC)
go

CREATE TABLE [SENSOR]
( 
	[SensorId]           integer  NOT NULL ,
	[Model]              varchar(100)  NULL ,
	[Type]               varchar(100)  NULL 
)
go

ALTER TABLE [SENSOR]
	ADD CONSTRAINT [XPKSENSOR] PRIMARY KEY  CLUSTERED ([SensorId] ASC)
go


ALTER TABLE [DATALOG]
	ADD CONSTRAINT [R_1] FOREIGN KEY ([SensorId]) REFERENCES [SENSOR]([SensorId])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go
