📘 Cloud Cost Intelligence Platform
Data Engineer Intern – Take-Home Assignment

Prepared by: Rohit Manvar

📌 Overview

This project demonstrates a complete multi-cloud cost intelligence platform designed for FinOps use cases. It includes data modeling, transformation logic, data quality validation, exploratory analysis, and an end-to-end pipeline architecture for AWS + GCP cloud billing.

The solution follows FinOps principles for:

Cost visibility & allocation

Multi-cloud normalization

Anomaly detection & insights

Team-wise & environment-wise reporting

Scalable data processing

📊 Key Features
✅ Unified Multi-Cloud Billing Schema

Standardized structure for AWS CUR & GCP Billing Export

Normalized field names, data types, and spending metrics

Extensible service dictionary

✅ Star-Schema Data Warehouse

Includes:

fact_billing (daily cost per cloud, service, team, project/account)

Dimension tables:

Time

Cloud provider

Service

Team

Environment

AWS account

GCP project

Optimized for FinOps cost reporting.

✅ Data Quality Validation

Covers:

Duplicate checks

Invalid/missing dates

Missing dimensional attributes

Service mismatches

Negative cost validations

Project/account mapping consistency

✅ SQL Transformations

Includes SQL for:

Unified multi-cloud spend view

Monthly spend by cloud provider

Spend by team & environment

Top 5 most expensive services

Cost anomaly identification

✅ Pipeline Architecture (Medallion Model)

Bronze → Silver → Gold multilayered design:

Bronze → Raw billing from S3/GCS

Silver → Cleaned & normalized billing

Gold → Final analytics marts

Technologies used:

Layer	Technology
Ingestion	Airflow DAGs
Storage	S3 / GCS
Data Warehouse	Snowflake
Transformation	dbt
Quality	Great Expectations
Visualization	Tableau
🧱 Data Model (Star Schema)

fact_billing is stored at daily granularity combining:
cloud_provider + project/account + service + team + environment + date

Dimensions include:

dim_time

dim_cloud_provider

dim_service

dim_team

dim_environment

dim_aws_account

dim_gcp_project

Supports:

Multi-cloud normalization

Showback/chargeback allocation

Credits as negative cost

Service categorization

🛠 SQL Transformations Available

The repository includes queries for:

1. Unified Spend Table

Standardized AWS + GCP spend with:

cloud_provider  
service  
project/account  
environment  
team  
cost_usd  
date  

2. Monthly Spend by Cloud

Aggregated spend by:

Month

AWS vs GCP

3. Spend by Team & Environment

Drilling into:

Team-wise cost

Environment: prod, dev, staging

4. Top Services

Top 5 high-cost services across clouds.

📈 Insights Example
🔍 Unexpected AWS EC2 Spend Spike (34%)

No corresponding workload growth

Possible anomalies:

Orphaned EC2 instances

Auto-scaling misconfiguration

Recommended Actions:

Verify instance uptime

Review Auto Scaling group logs

Set cost guardrails & alerts

📬 Contact

Rohit Manvar
