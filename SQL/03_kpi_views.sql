-- Author: Soundarya Sainathan
-- Project: SaaSGuard – Churn Early Warning Analytics
-- File: 03_kpi_views.sql
-- Purpose: Create KPI Views to detect churn early
-- Date: 2025-11-07

USE SaaSGuardDB;
GO

-------------------------------------------------------------
-- KPI 1: Daily Active Accounts (DAA)
-------------------------------------------------------------
CREATE VIEW sg.vKPI_DailyActiveAccounts AS
SELECT
    d.FullDate,
    COUNT(DISTINCT f.AccountID) AS ActiveAccountCount
FROM sg.FactDashboardUsage f
JOIN sg.DimDate d ON d.DateID = f.DateID
WHERE f.DashboardViews > 0
GROUP BY d.FullDate;
GO

-------------------------------------------------------------
-- KPI 2: Rolling 30 Day Usage Decline
-------------------------------------------------------------
CREATE VIEW sg.vKPI_Rolling30DropRate AS
SELECT
    a.AccountID,
    a.AccountName,

    SUM(CASE WHEN d.FullDate BETWEEN DATEADD(DAY,-60,CAST(GETUTCDATE() AS date)) 
                               AND DATEADD(DAY,-31,CAST(GETUTCDATE() AS date)) 
             THEN f.DashboardViews ELSE 0 END) AS Old30DaysViews,

    SUM(CASE WHEN d.FullDate BETWEEN DATEADD(DAY,-30,CAST(GETUTCDATE() AS date)) 
                               AND CAST(GETUTCDATE() AS date)
             THEN f.DashboardViews ELSE 0 END) AS New30DaysViews,

    CASE 
        WHEN SUM(CASE WHEN d.FullDate BETWEEN DATEADD(DAY,-60,CAST(GETUTCDATE() AS date)) 
                                   AND DATEADD(DAY,-31,CAST(GETUTCDATE() AS date))
                       THEN f.DashboardViews ELSE 0 END) = 0
        THEN NULL
        ELSE 1 - (
            CAST(SUM(CASE WHEN d.FullDate BETWEEN DATEADD(DAY,-30,CAST(GETUTCDATE() AS date)) 
                                           AND CAST(GETUTCDATE() AS date)
                           THEN f.DashboardViews ELSE 0 END) AS FLOAT)
            /
            NULLIF(
                SUM(CASE WHEN d.FullDate BETWEEN DATEADD(DAY,-60,CAST(GETUTCDATE() AS date)) 
                                       AND DATEADD(DAY,-31,CAST(GETUTCDATE() AS date))
                         THEN f.DashboardViews ELSE 0 END),
                0
            )
        ) 
    END AS DropRate

FROM sg.FactDashboardUsage f
JOIN sg.DimDate d ON d.DateID = f.DateID
JOIN sg.DimCustomerAccount a ON a.AccountID = f.AccountID
GROUP BY a.AccountID,a.AccountName;
GO

-------------------------------------------------------------
-- KPI 3: Final Churn Risk Ranking
-------------------------------------------------------------
CREATE VIEW sg.vKPI_ChurnRiskRanking AS
SELECT 
    r.AccountID,
    r.AccountName,
    r.DropRate,
    CASE 
        WHEN r.DropRate >= 0.60 THEN 'HIGH RISK'
        WHEN r.DropRate >= 0.30 THEN 'MEDIUM RISK'
        ELSE 'LOW RISK'
    END AS RiskLevel
FROM sg.vKPI_Rolling30DropRate r;
GO
