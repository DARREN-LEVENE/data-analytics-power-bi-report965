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

### Completed Star Schema Data Model:

![Screenshot 2024-02-12 123113](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/88a7a5c6-b575-4a20-971d-967298ddd0c5)


## Creating the Power BI Report

Report pages for **Executive Summary**, **Customer Detail**, **Product Detail** and **Stores Map** were created, together with colour theme and navigation sidebar.


### Building the Customer Detail Page

This page of the report has a customer focused analysis, and includes the following visuals:

#### Card visuals for total distinct customers and revenue per customer

![image](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/622954ad-45b9-4ed3-8ed7-ced642fb37b7)

Created as follows:

![Screenshot 2024-02-12 140712](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/b3bf484d-7316-4bca-8fb4-a98985198050)


#### A line chart of distinct customers over time (time period can be drilled down)

![Screenshot 2024-02-12 140958](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/2842e2e6-8df9-45cc-a4a4-2e6ed06d33cb)

Created as follows:

![Screenshot 2024-02-12 141127](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/a2164b41-6e35-4abc-a144-81a62f890d4c)


Other visuals created for the **Customer Detail** page were as follows:
-  A table showing the top 20 customers by total revenue, showing revenue per customer, and the total orders for each customer.
-  A Donut chart showing the number of customers by country, and a Bar chart showing the number of customers by product category.
-  A set of three card visuals showing the name, number of orders , and revenue for the top customer by revenue.
-  A date slicer

### Completed Customer Detail Page

![Screenshot 2024-02-12 172803](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/28bbf4ed-473c-4b23-951f-602fab901864)

### Building the Executive Summary Page

This page of the report is intended for high level executives, as an overview of the performance of the business as a whole to gain insights, and easily check actual performance against benchmarks and targets.
The Executive Summary contains the following visuals:

#### Graph of Revenue against Time
The graph has functionality to enable user to drill down timescale to different time periods

![Screenshot 2024-02-13 095401](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/b4b694b0-bf25-4524-a448-ee87bcaeb227)

Created as follows:

![Screenshot 2024-02-13 095615](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/9b0e72dc-7841-46f7-9284-050a50096bd1)

#### KPI cards for Quarterly Revenue, Profit and Orders
These cards show the actual performance versus the Quarterly Growth target, which was calculated as the 5% increase on previous quarter. This was defined in a calculated measure as follows:

``Quarterly Profit Growth Target = [Previous Quarter Profit]*1.05``

![image](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/0a576673-c296-49bf-8f15-bd427b4522a4)


The KPI card visual was constructed as follows:

![Screenshot 2024-02-13 102103](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/c8c2d813-9966-4283-b0a0-10cc2d8bd4d0)

DAX for Previous Quarter Profit, which was used in the DAX formula for Quarterly Profit growth target:

![Screenshot 2024-02-14 090725](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/c1a5aa05-724c-46da-87f8-13ea6fb49cbf)

In addition to this, visuals were produced for the following:
-  Card visuals for Total Revenue, Total Profit and Total Orders
-  Donut charts showing orders and revenue by country
-  Bar chart of Orders by category
-  Table of Top 10 products

### Completed Executive Summary page

![Screenshot 2024-02-14 141024](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/dffe4eec-4bab-41cf-83e1-89cc24f437d3)


### Building the Products Detail page

This page is designed to provide executives with an in-depth look at which products within the inventory are performing well, with the option to filter by product and region.

#### Card visuals showing which filters are currently selected
The following Slicer Toolbar was constructed using bookmarks to allow user to select Product Category and Country filters for page visuals

![Screenshot 2024-02-14 142932](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/de831e8c-9f6f-4eda-80e6-dffbddcfd42d)

#### Slicer Toolbar was constructed as follows:

![Screenshot 2024-02-14 143535](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/704084bf-913f-4c38-923a-027d5308e799)

#### Area chart showing relative performance of each category over time

![Screenshot 2024-02-14 143015](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/a091378c-c196-4995-af0b-82dca125f859)

#### Area chart was constructed as follows:

![Screenshot 2024-02-14 144852](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/dc3bd74d-79bc-4868-9148-94ae8b1c5932)

In addition, further visuals were created for the Product Detail page:
-  Gauge visuals to show how the selected categories revenue, profit and number of orders are performing against a quarterly target, which was a 10% increase in previous quarter performance.
-  Table showing top 10 products by revenue in the selected context.
-  Scatter graph of the quantity ordered against profit per item for products in the current context.

### Completed Product Detail page

![Screenshot 2024-02-14 145847](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/91b2ac32-74b5-49a7-8cf9-f33c6ad86567)


### Building the Stores Map page

This page allows regional management to easily access management information of stores within their remit. For example, which of their stores are the most profitable, as well as to see at a glance 
which stores are on track to achieve their quarterly profit and revenue targets.

A map visual and country slicer was added to the page, to enable users to select which countries / regions to look at on the map visual.

#### Stores Drillthrough page






    
