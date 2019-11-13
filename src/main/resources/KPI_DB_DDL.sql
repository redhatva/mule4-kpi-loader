IF EXISTS (SELECT 1 FROM Sysobjects where xtype = 'V' and name = 'BusinessGroup_Environment')
BEGIN
	drop view BusinessGroup_Environment;
END;
go

IF EXISTS (SELECT 1 FROM Sysobjects where xtype = 'U' and name = 'CloudHubApplication')
BEGIN
	drop table CloudHubApplication;
END;
go

IF EXISTS (SELECT 1 FROM Sysobjects where xtype = 'U' and name = 'CloudHubApplication_History')
BEGIN
	drop table CloudHubApplication_History;
END;
go

IF EXISTS (SELECT 1 FROM Sysobjects where xtype = 'U' and name = 'RoleMapping')
BEGIN
	drop table RoleMapping;
END;
go

IF EXISTS (SELECT 1 FROM Sysobjects where xtype = 'U' and name = 'RoleMapping_History')
BEGIN
	drop table RoleMapping_History;
END;
go

IF EXISTS (SELECT 1 FROM Sysobjects where xtype = 'U' and name = 'Environment')
BEGIN
	drop table Environment;
END;
go

IF EXISTS (SELECT 1 FROM Sysobjects where xtype = 'U' and name = 'Environment_History')
BEGIN
	drop table Environment_History;
END;
go

IF EXISTS (SELECT 1 FROM Sysobjects where xtype = 'U' and name = 'BusinessGroup')
BEGIN
	drop table BusinessGroup;
END;
go

IF EXISTS (SELECT 1 FROM Sysobjects where xtype = 'U' and name = 'BusinessGroup_History')
BEGIN
	drop table BusinessGroup_History;
END;
go

IF EXISTS (SELECT 1 FROM SYSOBJECTS WHERE xtype='TR' and name = 'tr_BusinessGroup_insert')
BEGIN
	drop trigger tr_BusinessGroup_insert;
END;
go

CREATE TABLE BusinessGroup (
	ID INT IDENTITY(1,1),
	EXT_ID varchar(200) not null,
	NAME varchar(200) not null,
	CREATED_AT datetime null,
	UPDATED_AT datetime null,
	OWNER varchar(200) null,
	VC_PROD_ALLOCATED decimal(10,2) null,
	VC_PROD_USED decimal(10,2) null,
	VC_SBOX_ALLOCATED decimal(10,2) null,
	VC_SBOX_USED decimal(10,2) null,
	VC_DESGN_ALLOCATED decimal(10,2) null,
	VC_DESGN_USED decimal(10,2) null,
	PRIMARY KEY(ID),
	CONSTRAINT AK_BusinessGroup_External_ID UNIQUE(EXT_ID)
);
go

CREATE TABLE BusinessGroup_History (
	ID INT,
	EXT_ID varchar(200) not null,
	NAME varchar(200) not null,
	CREATED_AT datetime null,
	UPDATED_AT datetime null,
	OWNER varchar(200) null,
	VC_PROD_ALLOCATED decimal(10,2) null,
	VC_PROD_USED decimal(10,2) null,
	VC_SBOX_ALLOCATED decimal(10,2) null,
	VC_SBOX_USED decimal(10,2) null,
	VC_DESGN_ALLOCATED decimal(10,2) null,
	VC_DESGN_USED decimal(10,2) null,
	SNAPSHOT_AT datetime null
);
go

CREATE TRIGGER tr_BusinessGroup_insert 
	ON BusinessGroup 
	AFTER INSERT
AS
BEGIN
	INSERT INTO BusinessGroup_History (ID, EXT_ID, NAME, CREATED_AT, UPDATED_AT, OWNER, 
	VC_PROD_ALLOCATED,
	VC_PROD_USED ,
	VC_SBOX_ALLOCATED ,
	VC_SBOX_USED ,
	VC_DESGN_ALLOCATED ,
	VC_DESGN_USED ,
	SNAPSHOT_AT)
	SELECT ID, EXT_ID, NAME, CREATED_AT, UPDATED_AT, OWNER, 
	VC_PROD_ALLOCATED,
	VC_PROD_USED ,
	VC_SBOX_ALLOCATED ,
	VC_SBOX_USED ,
	VC_DESGN_ALLOCATED ,
	VC_DESGN_USED ,
	getdate()
	FROM inserted;
END;
go

CREATE TABLE Environment (
    ID INT IDENTITY(1,1),
	BG_ID int not null,
    EXT_ID varchar(200) not null,
    NAME varchar(200) not null,
	TYPE varchar(200) not null,
	PRIMARY KEY(ID),
	CONSTRAINT AK_Environment_External_ID UNIQUE(EXT_ID),
	CONSTRAINT FK_BusinessGroupEnvironment FOREIGN KEY (BG_ID) 
		REFERENCES BusinessGroup(ID)
);
go

CREATE TABLE Environment_History (
    ID INT,
	BG_ID int not null,
    EXT_ID varchar(200) not null,
    NAME varchar(200) not null,
	TYPE varchar(200) not null,
	SNAPSHOT_AT datetime null
);
go

CREATE TRIGGER tr_Environment_insert 
	ON Environment 
	AFTER INSERT
AS
BEGIN
	INSERT INTO Environment_History (ID, BG_ID, EXT_ID, NAME, TYPE, SNAPSHOT_AT)
	SELECT ID, BG_ID, EXT_ID, NAME, TYPE, getdate()
	FROM inserted;
END;
go

CREATE TABLE RoleMapping (
    ID INT IDENTITY(1,1),
	BG_ID int not null,
    NAME varchar(200) not null,
	AD_GROUP varchar(200) null
	PRIMARY KEY(ID),
	CONSTRAINT FK_BusinessGroupRoleMapping FOREIGN KEY (BG_ID) 
		REFERENCES BusinessGroup(ID)
);
go

CREATE TABLE RoleMapping_History (
    ID INT,
	BG_ID int not null,
    NAME varchar(200) not null,
	AD_GROUP varchar(200) null,
	SNAPSHOT_AT datetime null
);
go

CREATE TRIGGER tr_RoleMapping_insert 
	ON RoleMapping 
	AFTER INSERT
AS
BEGIN
	INSERT INTO RoleMapping_History (ID, BG_ID, NAME, AD_GROUP, SNAPSHOT_AT)
	SELECT ID, BG_ID, NAME, AD_GROUP, getdate()
	FROM inserted;
END;
go

CREATE TABLE CloudHubApplication (
    ID INT IDENTITY(1,1),
	BG_ID int not null,
	ENV_ID int not null,
    EXT_ID varchar(200) not null,
    DOMAIN varchar(200) not null,
	FULL_DOMAIN varchar(200) not null,
	HREF varchar(255) null,
	WORKER_STATUS varchar(200) null,
	WORKER_COUNT int null,
	WORKER_SIZE decimal(10,2) null,
	WORKER_VERSION varchar(50) null,
	WORKER_REGION varchar(50) null,
	LAST_UPDATED datetime null,
	DEPLOYED_FILENAME varchar(255) null,
	DEPLOYMENT_GROUP varchar(200) null,
	STATIC_IP smallint null,
	IP_ADDRESSES varchar(200) null,
	PERSISTENT_QUEUE smallint null,
	ENCRYPTED_QUEUE smallint null,
	AUTO_RESTART smallint null,
	LOGGING_OOB smallint null,
	LOGGING_CUSTOM smallint null,
	PRIMARY KEY(ID),
	CONSTRAINT AK_CloudHubApplication_External_ID UNIQUE(EXT_ID),
	CONSTRAINT FK_BusinessGroupCloudHubApplication FOREIGN KEY (BG_ID) 
		REFERENCES BusinessGroup(ID),
	CONSTRAINT FK_EnvironmentCloudHubApplication FOREIGN KEY (ENV_ID) 
		REFERENCES Environment(ID)
);
go

CREATE TABLE CloudHubApplication_History (
    ID INT,
	BG_ID int not null,
	ENV_ID int not null,
    EXT_ID varchar(200) not null,
    DOMAIN varchar(200) not null,
	FULL_DOMAIN varchar(200) not null,
	HREF varchar(255) null,
	WORKER_STATUS varchar(200) null,
	WORKER_COUNT int null,
	WORKER_SIZE decimal(10,2) null,
	WORKER_VERSION varchar(50) null,
	WORKER_REGION varchar(50) null,
	LAST_UPDATED datetime null,
	DEPLOYED_FILENAME varchar(255) null,
	DEPLOYMENT_GROUP varchar(200) null,
	STATIC_IP smallint null,
	IP_ADDRESSES varchar(200) null,
	PERSISTENT_QUEUE smallint null,
	ENCRYPTED_QUEUE smallint null,
	AUTO_RESTART smallint null,
	LOGGING_OOB smallint null,
	LOGGING_CUSTOM smallint null,
	SNAPSHOT_AT datetime null
);
go

CREATE TRIGGER tr_CloudHubApplication_insert 
	ON CloudHubApplication 
	AFTER INSERT
AS
BEGIN
	INSERT INTO CloudHubApplication_History (ID, BG_ID, ENV_ID, EXT_ID, DOMAIN, FULL_DOMAIN, HREF, WORKER_STATUS, WORKER_COUNT, WORKER_SIZE, WORKER_VERSION, WORKER_REGION, LAST_UPDATED, DEPLOYED_FILENAME, DEPLOYMENT_GROUP, STATIC_IP, IP_ADDRESSES, PERSISTENT_QUEUE, ENCRYPTED_QUEUE, AUTO_RESTART, LOGGING_OOB, LOGGING_CUSTOM, SNAPSHOT_AT)
	SELECT ID, BG_ID, ENV_ID, EXT_ID, DOMAIN, FULL_DOMAIN, HREF, WORKER_STATUS, WORKER_COUNT, WORKER_SIZE, WORKER_VERSION, WORKER_REGION, LAST_UPDATED, DEPLOYED_FILENAME, DEPLOYMENT_GROUP, STATIC_IP, IP_ADDRESSES, PERSISTENT_QUEUE, ENCRYPTED_QUEUE, AUTO_RESTART, LOGGING_OOB, LOGGING_CUSTOM, getdate()
	FROM inserted;
END;
go

CREATE VIEW BusinessGroup_Environment
AS
	select env.bg_id as [BusinessGroup_PKID], bg.ext_id as [BusinessGroup_External_ID], bg.name as [BusinessGroup_Name], env.ID as [Environment_PKID], env.EXT_ID as [Environment_External_ID], env.name as [Environment_Name]
	from environment env
	inner join businessgroup bg on bg.id = env.bg_id
;
go