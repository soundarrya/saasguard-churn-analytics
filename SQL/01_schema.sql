-- Author: Soundarya Sainathan
-- Project: SaaSGuard – Churn Early Warning Analytics
-- File: 01_schema.sql
-- Purpose: Create schema + dimension tables + fact table
-- Date: 2025-11-07

USE SaaSGuardDB;
GO

-------------------------------------------------------------
-- Create Schema
-------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name='sg')
    EXEC('CREATE SCHEMA sg');
GO

-------------------------------------------------------------
-- Dimension: Enterprise Customer Accounts
-------------------------------------------------------------
CREATE TABLE sg.DimCustomerAccount (
    AccountID      INT IDENTITY(1,1) PRIMARY KEY,
    AccountName    VARCHAR(150) NOT NULL,
    Industry       VARCHAR(80)  NOT NULL,
    Country        VARCHAR(60)  NOT NULL,
    CreatedAt      DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME()
);

-------------------------------------------------------------
-- Dimension: User Profile (individual users inside SaaS account)
-------------------------------------------------------------
CREATE TABLE sg.DimUserProfile (
    UserID         INT IDENTITY(1,1) PRIMARY KEY,
    AccountID      INT NOT NULL REFERENCES sg.DimCustomerAccount(AccountID),
    RoleType       VARCHAR(40) NOT NULL CHECK (RoleType IN ('Analyst','Manager','Executive','Data Scientist')),
    SeniorityLevel VARCHAR(20) NOT NULL CHECK (SeniorityLevel IN ('Junior','Mid','Senior')),
    CreatedAt      DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME()
);

-------------------------------------------------------------
-- Dimension: Calendar Date
-------------------------------------------------------------
CREATE TABLE sg.DimDate (
    DateID     INT        NOT NULL PRIMARY KEY,  
    FullDate   DATE       NOT NULL UNIQUE,
    [Year]     SMALLINT   NOT NULL,
    [Month]    TINYINT    NOT NULL CHECK ([Month] BETWEEN 1 AND 12),
    [Day]      TINYINT    NOT NULL CHECK ([Day]   BETWEEN 1 AND 31)
);

-------------------------------------------------------------
-- Fact Table: Daily Dashboard Usage
-------------------------------------------------------------
CREATE TABLE sg.FactDashboardUsage
(
    UsageID        BIGINT IDENTITY(1,1) PRIMARY KEY,
    AccountID      INT NOT NULL REFERENCES sg.DimCustomerAccount(AccountID),
    UserID         INT NOT NULL REFERENCES sg.DimUserProfile(UserID),
    DateID         INT NOT NULL REFERENCES sg.DimDate(DateID),
    DashboardViews INT NOT NULL CHECK (DashboardViews >=0),
    InsertedAt     DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME()
);

CREATE INDEX IX_FactDash_AccountDate ON sg.FactDashboardUsage(AccountID, DateID);
GO
