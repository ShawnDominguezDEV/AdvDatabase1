--Check to ensure the database does not already exist before creating it.
USE [master]
GO

if EXISTS (SELECT name from sys.databases WHERE name = N'ServiceDB-sdd65')
	BEGIN
		-- CLOSE CONNECTION TO THE DWPUBSALES DATABASE
		ALTER DATABASE [ServiceDB-sdd65] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
		DROP DATABASE [ServiceDB-sdd65]
	END
GO


CREATE DATABASE [ServiceDB-sdd65]
GO


--Switch focus to new database

USE [ServiceDB-sdd65]
GO

--Create Tables

--Driver Table
CREATE TABLE dbo.Driver
(
	Driver_Id	nchar(5) NOT NULL,	
	LastName	nchar(50),
	FirstName	nchar(50),
	DateOfBirth	datetime,
	CONSTRAINT [PK_Driver] PRIMARY KEY ([Driver_Id] ASC)
)
	
GO

--City Table
CREATE TABLE dbo.City
(
	City_Code	nchar(5) NOT NULL,	
	CountryName	nchar(50),
	CONSTRAINT [PK_City] PRIMARY KEY ([City_Code] ASC)
)
	
GO

--Street Table
CREATE TABLE dbo.Street
(
	Street_Code	nchar(10) NOT NULL,	
	StreetName	nchar(50),
	ZipCode		char(5),
	City_Code	nchar(5),
	CONSTRAINT [PK_Street] PRIMARY KEY ([Street_Code] ASC)
)
	
GO

--Trip Table
CREATE TABLE dbo.Trip
(
	number		char(10) NOT NULL,	
	Date		datetime NOT NULL,
	charge		decimal(18,2),
	mileage		decimal(18,2),		--Corrected spelling of mileage
	payment_no	int,
	Street_Code	nchar(10),
	Driver_Id	nchar(5),
	CONSTRAINT [PK_Trip] PRIMARY KEY ([number] ASC)
)
	
GO

--Define Foreign Keys
Alter Table dbo.Street With Check 
	Add Constraint [FK_Street_City] 
		Foreign Key (City_Code) References dbo.City (City_Code)
Go

Alter Table dbo.Trip With Check 
	Add Constraint [FK_Trip_Street] 
		Foreign Key (Street_Code) References dbo.Street (Street_Code)
Go

Alter Table dbo.Trip With Check 
	Add Constraint [FK_Trip_Driver] 
		Foreign Key (Driver_Id) References dbo.Driver (Driver_ID)
Go

--Notify if successful
Select Message = 'ServiceDB OLTP Database created!' 