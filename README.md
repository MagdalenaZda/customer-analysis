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
TO_DATE(dt_customer, 'DD-MM-YYYY')



## Data Source 
https://www.kaggle.com/datasets/imakash3011/customer-personality-analysis
