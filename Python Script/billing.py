import pandas as pd

#Load Data
aws = "aws_line_items_12mo.csv"
gcp = "gcp_billing_12mo.csv"

adf = pd.read_csv(aws)
gdf = pd.read_csv(gcp)

#Convert date to datetime
adf['date'] = pd.to_datetime(adf['date'], format='%Y-%m-%d', errors='coerce')
gdf['date'] = pd.to_datetime(gdf['date'], format='%Y-%m-%d', errors='coerce')

#print(adf.head())
#print(gdf.head())

#Row Counts
print("\n--- Row Counts ---")
print(f"AWS rows: {len(adf)}")
print(f"GCP rows: {len(gdf)}")

#Missing / Null Values
print("\n--- Missing / Null Values ---")
print("AWS:")
print(adf.isnull().sum())
print("\nGCP:")
print(gdf.isnull().sum())

#Duplicate Records
print("\n--- Duplicate Records ---")
# Exact duplicates
print(f"AWS exact duplicates: {adf.duplicated().sum()}")
print(f"GCP exact duplicates: {gdf.duplicated().sum()}")

#field key duplicates (date + service + team + env + id)
print(f"AWS field key duplicates: {adf.duplicated(subset=['date','service','team','env','account_id']).sum()}")
print(f"GCP field key duplicates: {gdf.duplicated(subset=['date','service','team','env','project_id']).sum()}")

#Unexpected Values
print("\n--- Unexpected Values ---")
# Env
print("AWS env values:", adf['env'].unique())
print("GCP env values:", gdf['env'].unique())

# Services
print("AWS service names:", adf['service'].unique())
print("GCP service names:", gdf['service'].unique())

# Date Ranges
print(f"AWS Date Range: {adf['date'].min()} to {adf['date'].max()}")
print(f"GCP Date Range: {gdf['date'].min()} to {gdf['date'].max()}")

#Negative or zero cost
aws_negative = (adf['cost_usd'] <= 0).sum()
gcp_negative = (gdf['cost_usd'] <= 0).sum()
print(f"\nAWS negative or zero cost rows: {aws_negative}")
print(f"GCP negative or zero cost rows: {gcp_negative}")

#Team value distribution
print("\n--- Team Distribution ---")
print("AWS teams:")
print(adf['team'].value_counts())
print("\nGCP teams:")
print(gdf['team'].value_counts())

#duplicates for inspection
print("\n--- Sample AWS Business-key Duplicates ---")
print(adf[adf.duplicated(subset=['date','service','team','env','account_id'], keep=False)].head(10))

print("\n--- Sample GCP Business-key Duplicates ---")
print(gdf[gdf.duplicated(subset=['date','service','team','env','project_id'], keep=False)].head(10))

