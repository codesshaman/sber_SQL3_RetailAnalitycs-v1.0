-- Create the database
CREATE DATABASE your_database_name;

-- Use the database
USE your_database_name;

-- Create the Customers table
CREATE TABLE Customers (
  Customer_ID INT PRIMARY KEY,
  Customer_Name VARCHAR(255),
  Customer_Surname VARCHAR(255),
  Customer_Primary_Email VARCHAR(255),
  Customer_Primary_Phone VARCHAR(255)
);

-- Create the Cards table
CREATE TABLE Cards (
  Customer_Card_ID INT PRIMARY KEY,
  Customer_ID INT,
  FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID)
);

-- Create the Transactions table
CREATE TABLE Transactions (
  Transaction_ID INT PRIMARY KEY,
  Customer_Card_ID INT,
  Transaction_Summ DECIMAL(10, 2),
  Transaction_DateTime DATETIME,
  Transaction_Store_ID INT,
  FOREIGN KEY (Customer_Card_ID) REFERENCES Cards(Customer_Card_ID)
);

-- Create the Checks table
CREATE TABLE Checks (
  Transaction_ID INT,
  SKU_ID INT,
  SKU_Amount INT,
  SKU_Summ DECIMAL(10, 2),
  SKU_Summ_Paid DECIMAL(10, 2),
  SKU_Discount DECIMAL(10, 2),
  FOREIGN KEY (Transaction_ID) REFERENCES Transactions(Transaction_ID)
);

-- Create the Product Grid table
CREATE TABLE Product_Grid (
  SKU_ID INT PRIMARY KEY,
  SKU_Name VARCHAR(255),
  Group_ID INT,
  SKU_Purchase_Price DECIMAL(10, 2),
  SKU_Retail_Price DECIMAL(10, 2),
  FOREIGN KEY (Group_ID) REFERENCES SKU_Group(Group_ID)
);

-- Create the Stores table
CREATE TABLE Stores (
  Transaction_Store_ID INT PRIMARY KEY,
  SKU_ID INT,
  SKU_Purchase_Price DECIMAL(10, 2),
  SKU_Retail_Price DECIMAL(10, 2),
  FOREIGN KEY (SKU_ID) REFERENCES Product_Grid(SKU_ID)
);

-- Create the SKU Group table
CREATE TABLE SKU_Group (
  Group_ID INT PRIMARY KEY,
  Group_Name VARCHAR(255)
);

-- Create the Date of Analysis Formation table
CREATE TABLE Date_of_Analysis_Formation (
  Analysis_Formation DATETIME PRIMARY KEY
);

-- Create the Customers View
CREATE VIEW Customers_View AS
SELECT
  c.Customer_ID,
  AVG(t.Transaction_Summ) AS Customer_Average_Check,
  CASE
    WHEN AVG(t.Transaction_Summ) >= 1000 THEN 'High'
    WHEN AVG(t.Transaction_Summ) >= 500 THEN 'Medium'
    ELSE 'Low'
  END AS Customer_Average_Check_Segment,
  COUNT(t.Transaction_ID) / DATEDIFF(MAX(t.Transaction_DateTime), MIN(t.Transaction_DateTime)) AS Customer_Frequency,
  CASE
    WHEN COUNT(t.Transaction_ID) / DATEDIFF(MAX(t.Transaction_DateTime), MIN(t.Transaction_DateTime)) >= 3 THEN 'Often'
    WHEN COUNT(t.Transaction_ID) / DATEDIFF(MAX(t.Transaction_DateTime), MIN(t.Transaction_DateTime)) >= 1 THEN 'Occasionally'
    ELSE 'Rarely'
  END AS Customer_Frequency_Segment,
  DATEDIFF(CURDATE(), MAX(t.Transaction_DateTime)) AS Customer_Inactive_Period,
  (COUNT(DISTINCT c.Customer_ID) - COUNT(DISTINCT t.Customer_ID)) / COUNT(DISTINCT c.Customer_ID) AS Customer_Churn_Rate,
  CASE
    WHEN (COUNT(DISTINCT c.Customer_ID) - COUNT(DISTINCT t.Customer_ID)) / COUNT(DISTINCT c.Customer_ID) >= 0.5 THEN 'High'
    WHEN (COUNT(DISTINCT c.Customer_ID) - COUNT(DISTINCT t.Customer_ID)) / COUNT(DISTINCT c.Customer_ID) >= 0.2 THEN 'Medium'
    ELSE 'Low'
  END AS Customer_Churn_Segment,
  1 AS Customer_Segment,
  s.Transaction_Store_ID AS Customer_Primary_Store
FROM
  Customers c
  LEFT JOIN Cards ca ON c.Customer_ID = ca.Customer_ID
  LEFT JOIN Transactions t ON ca.Customer_Card_ID = t.Customer_Card_ID
  LEFT JOIN Stores s ON t.Transaction_Store_ID = s.Transaction_Store_ID
GROUP BY
  c.Customer_ID;

-- Create the Purchase History View
CREATE VIEW Purchase_History_View AS
SELECT
  t.Customer_Card_ID AS Customer_ID,
  t.Transaction_ID,
  t.Transaction_DateTime,
  ch.SKU_ID,
  ch.SKU_Amount,
  ch.SKU_Summ AS Group_Cost,
  ch.SKU_Summ AS Group_Summ,
  ch.SKU_Summ_Paid,
  ch.SKU_Discount
FROM
  Transactions t
  INNER JOIN Checks ch ON t.Transaction_ID = ch.Transaction_ID;

-- Create the Periods View
CREATE VIEW Periods_View AS
SELECT
  t.Customer_Card_ID AS Customer_ID,
  pg.Group_ID,
  MIN(t.Transaction_DateTime) AS First_Group_Purchase_Date,
  MAX(t.Transaction_DateTime) AS Last_Group_Purchase_Date,
  COUNT(DISTINCT t.Transaction_ID) AS Group_Purchase,
  COUNT(DISTINCT t.Transaction_ID) / DATEDIFF(MAX(t.Transaction_DateTime), MIN(t.Transaction_DateTime)) AS Group_Frequency,
  MIN(ch.SKU_Discount) AS Group_Min_Discount
FROM
  Transactions t
  INNER JOIN Checks ch ON t.Transaction_ID = ch.Transaction_ID
  INNER JOIN Product_Grid pg ON ch.SKU_ID = pg.SKU_ID
GROUP BY
  t.Customer_Card_ID,
  pg.Group_ID;

-- Create the Groups View
CREATE VIEW Groups_View AS
SELECT
  t.Customer_Card_ID AS Customer_ID,
  pg.Group_ID,
  1 AS Group_Affinity_Index,
  1 AS Group_Churn_Rate,
  1 AS Group_Stability_Index,
  1 AS Group_Margin,
  1 AS Group_Discount_Share,
  1 AS Group_Minimum_Discount,
  1 AS Group_Average_Discount
FROM
  Transactions t
  INNER JOIN Checks ch ON t.Transaction_ID = ch.Transaction_ID
  INNER JOIN Product_Grid pg ON ch.SKU_ID = pg.SKU_ID;
