# Customer Personality Analysis

## Project Overview
This project focuses on **uncovering distinctive customer characteristics** and deciphering the underlying patterns that drive consumer behavior. The goal is to provide a granular view of how different demographics interact with products and marketing initiatives.

## Key Insights
* **Customer Profile:** The highest purchasing activity is shown by **Seniors** and **Middle-aged** individuals. These groups dominate all sales channels.
* **Sales Structure:** Sales are dominated by **Wine (35.8%)** and **Meat products (25.8%)**. Other categories serve as supplementary offerings.
* **Channel Preferences:** Despite the availability of online and catalog shopping, physical stores remain the primary contact point for every age segment.
* **Marketing:** Campaigns 3 and 4 recorded the highest response rates, suggesting superior effectiveness compared to other initiatives.

## The Process
1.**Import data**
* **Import Process:** The raw dataset was imported directly from a CSV format into a **PostgreSQL** environment.
* **Staging Strategy:** To prevent import failures due to formatting inconsistencies, all columns were initially loaded as **TEXT** into a temporary staging table.
  
2.**Data Transformation**
* Data was moved from the temporary table into structured production tables. During this process, **TEXT** values were converted into appropriate data types such as **INT**, **NUMERIC**, and **DATE**.
* To ensure a unified timeline for analysis, the `dt_customer` field was standardized using the `TO_DATE` function:
```sql
TO_DATE(dt_customer, 'DD-MM-YYYY')
```
* To enhance the analytical value of the dataset, I implemented custom feature engineering by categorizing customers based on their demographic and financial profiles. Using the `year_birth` column, customers were grouped into life-stage categories to identify the primary age demographics:
```sql
age_group = CASE
    WHEN (2026 - year_birth) < 40 THEN 'Young Adults'
    WHEN (2026 - year_birth) BETWEEN 40 AND 49 THEN 'Established Adults'
    WHEN (2026 - year_birth) BETWEEN 50 AND 59 THEN 'Mature Adults'
    ELSE 'Seniors'
END 
```
3.**Visualizations**

*Interactivity is driven by two primary types of slicers, allowing for granular data exploration:
* **List Slicers:** Implemented for both **Age Groups** and **Income Brackets**, enabling users to filter the entire report by specific demographic segments.
* **Tile Slicers:** Used for **Month Selection**, providing a clean, touch-friendly interface for temporal analysis.
Data Consistency and Cross-Filtering
To ensure a seamless analytical flow, **Mutual Cross-Filtering** has been enabled for all visual objects. Selecting a data point in one chart (e.g., a specific age group) automatically updates all other visuals to reflect the filtered context, maintaining absolute data consistency across the report.
* **KPI Cards** Total Customers:A real-time count of the unique customer base, Promotional Transactions: The total volume of transactions successfully completed under promotional campaigns.
## Tools

## Project Preview

## Data Source 
https://www.kaggle.com/datasets/imakash3011/customer-personality-analysis

## Full Documentation

