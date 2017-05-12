CREATE DATABASE [CarbonDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'CarbonDB_PRIMARY', FILENAME = N'/var/opt/mssql/data/CarbonDB_PRIMARY.mdf' , SIZE = 8192KB , FILEGROWTH = 65536KB ), 
 FILEGROUP [MOD] CONTAINS MEMORY_OPTIMIZED_DATA 
( NAME = N'CarbonDB_MOD', FILENAME = N'/var/opt/mssql/data/CarbonDB_MOD' ), 
 FILEGROUP [USER] 
( NAME = N'CarbonDB_USER', FILENAME = N'/var/opt/mssql/data/CarbonDB_USER.ndf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'CarbonDB_log', FILENAME = N'/var/opt/mssql/data/CarbonDB_log.ldf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [CarbonDB] SET COMPATIBILITY_LEVEL = 130
GO
ALTER DATABASE [CarbonDB] SET AUTO_CREATE_STATISTICS ON(INCREMENTAL = OFF)
GO
ALTER DATABASE [CarbonDB] SET AUTO_UPDATE_STATISTICS ON 
GO

USE [CarbonDB]
GO
IF NOT EXISTS (SELECT name FROM sys.filegroups WHERE is_default=1 AND name = N'PRIMARY') ALTER DATABASE [CarbonDB] MODIFY FILEGROUP [PRIMARY] DEFAULT
GO