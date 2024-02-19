# **Data Analytics Power BI Report Project for Multi-National Retailer**
![Screenshot 2024-02-11 145522](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/813db2d4-74b3-4db9-beb1-0fc9816a4840)



## Table of Contents
1  [Project Description](#project-description)

2  [Importing Data into Power BI](#importing-data-into-power-bi)
-  [Orders Fact Table](#orders-fact-table)
-  [Products Dimensions Table](#products-dimensions-table)
-  [Stores Dimension Table](#stores-dimension-table)
-  [Customers Dimension Table](#customers-dimension-table)

3  [Create the Data Model](#create-the-data-model)
-  [Build a Date Table](#build-a-date-table)
-  [Building Star Schema Data Model](#building-star-schema-data-model)
-  [Create Key Measures](#create-key-measures)

4  [Creating the Power BI Report](#creating-the-power-bi-report)
-  [Building the Customer Detail Page](#building-the-customer-detail-page)
-  [Building the Executive Summary Page](#building-the-executive-summary-page)
-  [Building the Products Detail page](#building-the-products-detail-page)
-  [Building the Stores Map page](#building-the-stores-map-page)
-  [Stores Drillthrough page](#stores-drillthrough-page)
-  [Store tooltip visual](#store-tooltip-visual)

5  [Gaining insights from the database using SQL queries](gaining-insights-from-the-database-using-sql-queries)



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
  

#### Orders Fact Table

``orders_powerbi`` table is the main fact table, containing information about each order. It was imported from Azure SQL Database using credentials provided for server_name, database_name, username and password, and using **Import** option in Power BI.
**Power Query Editor** was used to transform the data and accessed using:

![Screenshot 2024-02-11 152105](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/bc9d32b3-022a-4362-8408-aee72aaaa73d)


The following transformations were performed in Power Query Editor:
-  ``[Card Number]`` column deleted for data privacy.
- **Split Column** feature to separate the ``[Order Date]`` and ``[Shipping Date]`` columns into two distinct columns each: one for the date and another for the time.
-  Any rows where the ``[Order Date]`` column has missing or null values are filtered out and removed.
-  Columns in table are renamed to follow Power BI naming conventions for consistency.

Orders Table:

![Screenshot 2024-02-19 102029](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/5d489e3c-4b79-424a-bc4b-24d3a176b9ac)



#### Products Dimensions Table

The **Products** table contains information about each product sold by the company.
``Products.csv`` file was downloaded onto local computer, and then Power BI's **Get Data** option was used to import the file into the project:

![Screenshot 2024-02-11 193830](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/3e0dd763-f64a-4a41-8eb5-be82843c2222)

The following transformations were performed in Power Query Editor:
-  **Remove Duplicates** function was used on ``product_code`` column to ensure each product code was unique
-   Columns in table are renamed to follow Power BI naming conventions for consistency.

![Screenshot 2024-02-11 194837](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/7a2b0140-5ced-42ba-9d23-4c413a95b082)


Products Dimension Table:

![image](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/32226726-57b7-4939-a6ea-14963ef063f5)



#### Stores Dimension Table

The **Stores** table contains information about each store. Power BI's **Get Data** option was used to connect to Azure Blob Storage and import the **Stores** table into the project, using Blob storage credentials for account_name, Account Key
and Container Name.

Columns in table are renamed to follow Power BI naming conventions for consistency.

**Stores** Dimension Table:

![image](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/7ab6f6a5-c41c-4f61-b08c-fc90981c2a2f)



#### Customers Dimension Table

The **Customers** table contains information about every customer in each region. 

A ``Customers.zip`` file was downloaded and unzipped onto the local machine. Inside the zip file was a folder containing three CSV files, each with the same column format, one for each of the regions in which the company operates.

Power BI's **Get Data** option was used to import the **Customers** folder into the project. The Folder data connector was used to navigate to the folder, then **Combine and Transform** was selected to import the data. Power BI automatically 
appended the three files into one query.


-  ``Full Name`` column was created by combining the ``[First Name]`` and ``[Last Name]`` columns
-  Unused columns (eg. index columns) were deleted, and remaining columns were renamed to align with Power BI naming conventions

**Customers** Dimension Table:

![image](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/f2fbab87-11ea-4667-9012-8a1d9434bc4c)




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

![image](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/ffad9e52-d6e6-4388-8661-e3bf0874a9c5)



## Creating the Power BI Report

Report pages for **Executive Summary**, **Customer Detail**, **Product Detail** and **Stores Map** were created, together with colour theme and navigation sidebar.


### Building the Customer Detail Page

This page of the report has a customer focused analysis, and includes the following visuals:

#### Card visuals for total distinct customers and revenue per customer

![image](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/b4c79c64-3a9b-40f8-8725-ed69b0d78668)


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

![image](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/c5fa4c33-1541-4f9f-b059-dc9e0ffd2463)


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

![Screenshot 2024-02-19 103959](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/c6f29516-a54b-40ae-b3dc-40c48a45f792)



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

![image](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/94230908-a2b5-4628-b8d2-52d4cc3f9a58)



### Building the Stores Map page

This page allows regional management to easily access management information of stores within their remit. For example, which of their stores are the most profitable, as well as to see at a glance 
which stores are on track to achieve their quarterly profit and revenue targets.

A map visual and country slicer was added to the page, to enable users to select which countries / regions to look at on the map visual.

#### Stores Drillthrough page

This page gives management detailed information on each individual store, and includes the following visuals: 
-  Card visual showing currently selected store.
-  Table showing top 5 products, with coluns ofr **Description**, **Profit YTD**, **Total Orders** and **Total Revenue**
-  Column Chart showing **Total Orders** by **Product Category** for the store
-  Gauges for **Profit YTD** against a profit target of 20% year on year growth v same period previous year.

New measures of Profit Goal and Revenue Goal, reflecting 20% increase from previous year were written in DAX:

``Previous Year Profit = 
CALCULATE(
    TOTALYTD('Measures Table'[Total Profit],
            PREVIOUSYEAR(LASTDATE('Dates'[Date])
        )
    )
    )``

``Profit Goal = [Previous Year Profit]*1.2``

#### Drillthrough page Profit Goal gauge:

![Screenshot 2024-02-15 164837](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/c2ce8dd4-cdda-4f5f-a533-acd7995280fa)

Profit Goal Gauge was constructed as follows:

![Screenshot 2024-02-15 170001](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/d9847c74-7e03-4fd5-837b-9ed4c489d812)


#### Drillthrough page Top 5 Products table:

![Screenshot 2024-02-15 165202](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/208e4872-7e87-42b3-b663-75d258caa0d4)

Top 5 Product table constructed as follows:

![Screenshot 2024-02-15 170118](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/aaf4f220-1643-4051-b504-265b65344634)

#### Complete Drillthrough page example

![image](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/3afd14c7-cd4b-4c4b-a2d1-26685e6be4e5)

#### Store tooltip visual

This was created to display each stores year to date profit performance against profit target by hovering mouse over each store.

![Screenshot 2024-02-15 170405](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/a1db2c33-2f7f-4657-8da7-af329cac8619)

### Completed Stores Map page

![Screenshot 2024-02-15 170555](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/8e6a1d63-6c2b-43cb-adfe-82c1c62cbc61)


### Cross Filtering

Now that the report visuals have been completed, it is important to fix which visuals filter each other, and which ones shouldnt. The settings for each visual can
can be specified by utilising **Edit Interactions** button in **Format** tab of the ribbon.


![image](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/388fee7d-8b62-4e6d-bda2-0295e4e33436)


### Completing Navigation Bar

The navigation bar was completed, to allow users to easily navigate between report pages. This was set up with page icons to click onto for each page, which would change colour when mouse hovered.

![Screenshot 2024-02-16 102404](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/ca1be5eb-2c93-42d4-98f1-87ddd2ced2a1)                                   

![Screenshot 2024-02-16 102439](https://github.com/DARREN-LEVENE/data-analytics-power-bi-report965/assets/150942326/d9d13757-6ad8-4d05-8f5d-7c9c688f091a)


For each button on the navigation sidebar, **Action** format option was turned on, type set to **Page Navigation**, and the correct page selected for **Destination**

### Gaining insights from the database using SQL queries

The final part of the project was to gain insights from the database using SQL queries. This was done by connecting to Postgres database server hosted by Microsoft Azure.
This was done in VS Code with **SQLTools extension**, and connecting to database using appropriate credentials.

A list of tables in the database was printed and saved to csv file. Then, a list of columns in each table was printed and saved in csv files.

SQL queries were used to answer the following questions of the database:
-  How many staff are there in all of the UK stores?
-  Which month in 2022 has had the highest revenue?
-  Which German store type had the highest revenue for 2022?
-  Create a view where the rows are the store types and the columns are the total sales, percentage of total sales and the count of orders
-  Which product category generated the most profit for the "Wiltshire, UK" region in 2021?

SQL queries and results were recorded in full in the project's Github Repo


    
