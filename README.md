# **Data Analytics Power BI Report Project for Multi-National Retailer**
![Screenshot 2024-02-11 145522](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/813db2d4-74b3-4db9-beb1-0fc9816a4840)


## Project Description

This project considers the scenario of an international retailer who is keen to elevate their business intelligence practices. With operations spanning across different geographical regions, they have accumulated large amounts of data from varied sources over
a number of years.

The aim is to transform the data into actionable insights for better decision making. The goal of the project is to use Microsoft Power BI to design a comprehensive Quarterly report. This will involve extracting and transforming data from various origins,
designing a robust data model rooted in a star-based schema, and then constructing a multi-page report.

The report will present a high-level business summary tailored for senior executives, and also give insights into their highest value customers segmented by sales region, provide a detailed analysis of top-performing products categorised by type against their sales targets, 
and a visually appealing map visual tat spotlights theperformance metrics of their retail outlets across different territories.

## Importing Data into Power BI

The data set consists of four tables:
-  Orders Fact Table
-  Products Dimension Table
-  Stores Dimension Table
-  Customers Dimension Table

#### Import and Transform Orders Fact Table

``orders_powerbi`` table is the main fact table, containing information about each order. It was imported from Azure SQL Database using credentials provided for server_name, database_name, username and password, and using **Import** option in Power BI.
**Power Query Editor** was used to transform the data and accessed using:

![Screenshot 2024-02-11 152105](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/bc9d32b3-022a-4362-8408-aee72aaaa73d)


The following transformations were performed in Power Query Editor:
-  ``[Card Number]`` column deleted for data privacy.
- **Split Column** feature to separate the ``[Order Date]`` and ``[Shipping Date]`` columns into two distinct columns each: one for the date and another for the time.
-  Any rows where the ``[Order Date]`` column has missing or null values are filtered out and removed.
-  Columns in table are renamed to follow Power BI naming conventions for consistency.

Imported and Transformed Orders Table:

![Screenshot 2024-02-11 154445](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/1698d7f2-2423-45e6-8a63-5c1b2a8453b7)


#### Import and Transform Products Dimensions Table

The **Products** table contains information about each product sold by the company.
``Products.csv`` file was downloaded onto local computer, and then Power BI's **Get Data** option was used to import the file into the project:

![Screenshot 2024-02-11 193830](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/3e0dd763-f64a-4a41-8eb5-be82843c2222)

The following transformations were performed in Power Query Editor:
-  **Remove Duplicates** function was used on ``product_code`` column to ensure each product code was unique

![Screenshot 2024-02-11 194837](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/7a2b0140-5ced-42ba-9d23-4c413a95b082)

-  Columns in table are renamed to follow Power BI naming conventions for consistency.

Imported and Transformed Products Dimension Table:

![Screenshot 2024-02-11 195732](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/f8c127d9-60cb-4f7e-a9dc-3a19c86341e2)

#### Import and Transform Stores Dimension Table

The **Stores** table contains information about each store. Power BI's **Get Data** option was used to connect to Azure Blob Storage and import the **Stores** table into the project, using Blob storage credentials for account_name, Account Key
and Container Name.

Columns in table are renamed to follow Power BI naming conventions for consistency.

Imported **Stores** Dimension Table:

![image](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/1c1eda90-f0ba-440e-94dc-efb9f0fd5487)


#### Import and Transform Customers Dimension Table

The **Customers** table contains information about every customer in each region. 

A ``Customers.zip`` file was downloaded and unzipped onto the local machine. Inside the zip file was a folder containing three CSV files, each with the same column format, one for each of the regions in which the company operates.

Power BI's **Get Data** option was used to import the **Customers** folder into the project. The Folder data connector was used to navigate to the folder, then **Combine and Transform** was selected to import the data. Power BI automatically 
appended the three files into one query.


-  ``Full Name`` column was created by combining the ``[First Name]`` and ``[Last Name]`` columns
-  Unused columns (eg. index columns) were deleted, and remaining columns were renamed to align with Power BI naming conventions

Imported and Transformed **Customers** Dimension Table:

![image](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/d7603bdf-5b50-478a-8957-e9f595398d0b)








    
