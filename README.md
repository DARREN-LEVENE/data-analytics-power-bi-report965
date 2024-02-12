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



## Create the Data Model

#### Build a Date Table

Date table was constructed using DAX formula

```Dates = CALENDAR(MIN(Orders[Order Date]), MAX(Orders[Shipping Date]))```

DAX formulas were then used to add additional columns to the Date Table: Day of Week, Month Number (i.e. Jan = 1, Dec = 12 etc.), Month Name, Quarter, Year, Start of Year, Start of Quarter, Start of Month, Start of Week

DAX formula examples:

Month Name: ```Month Name = FORMAT(Dates[Date], "MMMM")```

Start of Month: ```Start of Month = STARTOFMONTH(Dates[Date])```

The **Date Table** was important as it acts as a basis for time intelligence within the data model.

A sepearate **Measures Table** was created for calculated measures. This was done in **Model View** with Power Query Editor.



#### Building Star Schema Data Model

"One-to-Many" relationships between the tables need to be established, in order to form the Star Schema. These were as follows:

``Products[product_code]`` to ``Orders[product_code]``

``Stores[store code]`` to ``Orders[Store Code]``

``Customers[User UUID]`` to ``Orders[User ID]``

``Date[date] to Orders[Order Date]`` (Active Relationship)

``Date[date] to Orders[Shipping Date]``



#### Create Key Measures

Some of the key measures that will be required in the report were created in the **Measures Table**, with DAX formulas:

``Total Orders = COUNT(Orders[Order Time])``

``Total Revenue = SUMX(Orders, Orders[Product Quantity]*RELATED(Products[Sale Price]))``

``Total Profit = SUMX(Orders, (RELATED(Products[Sale Price]) - RELATED(Products[Cost Price]))*Orders[Product Quantity])``

``Total Customers = COUNT(Orders[User ID])``

``Total Quantity = COUNT(Orders[Shipping Time])``

``Profit YTD = TOTALYTD([Total Profit], Orders[Order Date])``

``Revenue YTD = TOTALYTD([Total Revenue], Orders[Order Date])``


To enable appropriate drill down analysis for the report, appropriate **Date** and **Geography** heirarchies were added, as well as a new **Geography** calculated column in **Stores** table.

#### Completed Star Schema Data Model:

![Screenshot 2024-02-12 123113](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/88a7a5c6-b575-4a20-971d-967298ddd0c5)


## Creating the Power BI Report

Report pages for **Executive Summary**, **Customer Detail**, **Product Detail** and **Stores Map** were created, together with colour theme and navigation sidebar.


#### Building the Customer Detail Page

This page of the report has a customer focused analysis, and includes the following visuals:

#### Card visuals for total distinct customers and revenue per customer

![image](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/622954ad-45b9-4ed3-8ed7-ced642fb37b7)

Created as follows:

![Screenshot 2024-02-12 140712](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/b3bf484d-7316-4bca-8fb4-a98985198050)


#### A line chart of distinct customers over time (time period can be drilled down)

![Screenshot 2024-02-12 140958](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/2842e2e6-8df9-45cc-a4a4-2e6ed06d33cb)

Created as follows:

![Screenshot 2024-02-12 141127](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/a2164b41-6e35-4abc-a144-81a62f890d4c)


#### A table showing the top 20 customers by total revenue, showing revenue per customer, and the total orders for each customer.

![Screenshot 2024-02-12 141348](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/bb5d4757-a022-4ee8-ad45-bd5ea22e6a83)

Created as follows:

![Screenshot 2024-02-12 141459](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/36e70b88-3df6-4528-82a0-b7451a70cc89)


#### A Donut chart showing the number of customers by country, and a Bar chart showing the number of customers by product category.

![Screenshot 2024-02-12 141942](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/04514f63-1ce7-4519-9376-dc182f320ac7)


Created as follows:

![Screenshot 2024-02-12 142056](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/564f29a0-7902-4da4-a120-63da8e53bea5)


#### A set of three card visuals showing the name, number of orders , and revenue for the top customer by revenue.

![Screenshot 2024-02-12 143055](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/dedcdccc-a0f0-4560-864e-2c33e164438b)

Created as follows:

![Screenshot 2024-02-12 143128](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/72cb0ab1-f5ce-4bcb-8574-1f624762886f)


#### A date slicer

![image](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/ca66d0a6-e6ff-4e75-b24a-9a58869d997f)

Created as follows:

![Screenshot 2024-02-12 143543](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/f6a5a9e2-df7b-4084-ad98-9d93d6aafbde)











    
