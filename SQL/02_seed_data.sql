-- Author: Soundarya Sainathan
-- Project: SaaSGuard – Churn Early Warning Analytics
-- File: 02_seed_data.sql
-- Purpose: Insert sample accounts, users, dates and usage data
-- Date: 2025-11-07

USE SaaSGuardDB;
GO

-------------------------------------------------------------
-- 1) Seed Enterprise Accounts (10 accounts)
-------------------------------------------------------------
INSERT INTO sg.DimCustomerAccount(AccountName,Industry,Country)
VALUES
('FinNova Corp','FinTech','USA'),
('MedAxis Health','Healthcare','UK'),
('EcoSupply Global','Manufacturing','Germany'),
('RetailBoost Inc','E-Commerce','Canada'),
('CloudCore Systems','SaaS','USA'),
('GigaTel Telecom','Telecom','Australia'),
('BlueBank Digital','Financial Services','Singapore'),
('AeroSky Airlines','Aviation','UAE'),
('GreenField Energy','Clean Energy','Netherlands'),
('EduBoard Labs','EdTech','India');

-------------------------------------------------------------
-- 2) Seed Users (3 users per account = 30 users)
-------------------------------------------------------------
INSERT INTO sg.DimUserProfile(AccountID,RoleType,SeniorityLevel)
SELECT 
    a.AccountID,
    CASE WHEN ABS(CHECKSUM(NEWID()))%4=0 THEN 'Analyst'
         WHEN ABS(CHECKSUM(NEWID()))%4=1 THEN 'Manager'
         WHEN ABS(CHECKSUM(NEWID()))%4=2 THEN 'Executive'
         ELSE 'Data Scientist' END,
    CASE WHEN ABS(CHECKSUM(NEWID()))%3=0 THEN 'Junior'
         WHEN ABS(CHECKSUM(NEWID()))%3=1 THEN 'Mid'
         ELSE 'Senior' END
FROM sg.DimCustomerAccount a
CROSS APPLY (VALUES(1),(2),(3)) AS x(n);

-------------------------------------------------------------
-- 3) Seed DimDate (last 365 days)
-------------------------------------------------------------
;WITH d AS (
    SELECT TOP (365)
        CAST(DATEADD(DAY, -ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) +1, CAST(GETUTCDATE() AS date)) AS DATE) AS FullDate
    FROM sys.all_objects
)
INSERT INTO sg.DimDate(DateID, FullDate, [Year], [Month], [Day])
SELECT 
    (YEAR(FullDate)*10000) + (MONTH(FullDate)*100) + DAY(FullDate) AS DateID,
    FullDate,
    YEAR(FullDate),
    MONTH(FullDate),
    DAY(FullDate)
FROM d;

-------------------------------------------------------------
-- 4) Seed Usage Patterns (with drop in last 30 days)
-------------------------------------------------------------
;WITH Base AS (
    SELECT 
        u.UserID,
        u.AccountID,
        d.DateID,
        CASE 
            WHEN d.FullDate > DATEADD(DAY,-30,CAST(GETUTCDATE() AS date))
                 AND u.AccountID % 2 = 0 THEN ABS(CHECKSUM(NEWID()))%2     -- drop accounts
            ELSE ABS(CHECKSUM(NEWID()))%10                                -- normal accounts
        END AS Views
    FROM sg.DimUserProfile u
    CROSS JOIN sg.DimDate d
)
INSERT INTO sg.FactDashboardUsage(AccountID,UserID,DateID,DashboardViews)
SELECT AccountID,UserID,DateID,Views FROM Base;
GO
