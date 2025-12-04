USE WAREHOUSE COMPUTE_WH;

CREATE DATABASE IF NOT EXISTS FINOPS;
USE DATABASE FINOPS;

CREATE SCHEMA IF NOT EXISTS BILLING;
USE SCHEMA BILLING;

CREATE TABLE time (
    date_id       INT PRIMARY KEY,
    date          DATE,
    day           INT,
    month         INT,
    year          INT,
    week          INT,
    quarter       INT,
    fiscal_year   INT
);

CREATE TABLE cloud_provider (
    cloud_id      INT AUTOINCREMENT PRIMARY KEY,
    cloud_name    STRING,
    description   STRING
);

CREATE TABLE service (
    service_id        INT AUTOINCREMENT PRIMARY KEY,
    service_name      STRING,
    service_category  STRING,
    cloud_id          INT,
    FOREIGN KEY (cloud_id) REFERENCES dim_cloud_provider(cloud_id)
);

CREATE TABLE team (
    team_id        INT AUTOINCREMENT PRIMARY KEY,
    team_name      STRING,
    owner_email    STRING,
    department     STRING,
    cost_center    STRING
);

CREATE TABLE environment (
    env_id         INT AUTOINCREMENT PRIMARY KEY,
    env_name       STRING,
    env_type       STRING,
    is_production  BOOLEAN
);

CREATE TABLE aws_account (
    account_id     STRING PRIMARY KEY,
    account_name   STRING,
    cost_center    STRING
);

CREATE TABLE gcp_project (
    project_id     STRING PRIMARY KEY,
    project_name   STRING,
    cost_center    STRING
);

CREATE TABLE fact_billing (
    billing_id       INT AUTOINCREMENT PRIMARY KEY,
    date_id          INT,
    cloud_id         INT,
    service_id       INT,
    team_id          INT,
    env_id           INT,
    project_id       STRING,    
    account_id       STRING,    
    cost_usd         NUMBER(12,4),

    FOREIGN KEY (date_id)    REFERENCES dim_time(date_id),
    FOREIGN KEY (cloud_id)   REFERENCES dim_cloud_provider(cloud_id),
    FOREIGN KEY (service_id) REFERENCES dim_service(service_id),
    FOREIGN KEY (team_id)    REFERENCES dim_team(team_id),
    FOREIGN KEY (env_id)     REFERENCES dim_environment(env_id),
    FOREIGN KEY (project_id) REFERENCES dim_gcp_project(project_id),
    FOREIGN KEY (account_id) REFERENCES dim_aws_account(account_id)
);

--Create a unified, standardized spend table

CREATE OR REPLACE VIEW unified_cloud_spend AS
SELECT
    f.billing_id,
    t.date,
    t.year,
    t.month,
    cp.cloud_name AS cloud_provider,
    s.service_name,
    s.service_category,
    tm.team_name,
    e.env_name AS environment,
    COALESCE(f.project_id, f.account_id) AS resource_id,
    f.cost_usd
FROM fact_billing f
LEFT JOIN time t ON f.date_id = t.date_id
LEFT JOIN cloud_provider cp ON f.cloud_id = cp.cloud_id
LEFT JOIN service s ON f.service_id = s.service_id
LEFT JOIN team tm ON f.team_id = tm.team_id
LEFT JOIN environment e ON f.env_id = e.env_id;

--Compute monthly spend by cloud provider

SELECT
    year,
    month,
    cloud_provider,
    SUM(cost_usd) AS monthly_spend_usd
FROM unified_cloud_spend
GROUP BY year, month, cloud_provider
ORDER BY year, month, cloud_provider;

--Monthly spend by team & environment

SELECT
    year,
    month,
    team_name,
    environment,
    SUM(cost_usd) AS monthly_team_env_spend
FROM unified_cloud_spend
GROUP BY year, month, team_name, environment
ORDER BY year, month, team_name, environment;

--Top 5 most expensive services across both clouds

SELECT
    service_name,
    cloud_provider,
    SUM(cost_usd) AS total_spend
FROM unified_cloud_spend
GROUP BY service_name, cloud_provider
ORDER BY total_spend DESC
LIMIT 5;

