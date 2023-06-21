-- Create the Personal information table
CREATE TABLE IF NOT EXISTS Personal_Information (
  Customer_ID INT PRIMARY KEY,
  Customer_Name VARCHAR(255),
  Customer_Surname VARCHAR(255),
  Customer_Primary_Email VARCHAR(255),
  Customer_Primary_Phone VARCHAR(255)
);

-- Create the Cards table
CREATE TABLE IF NOT EXISTS Cards (
  Customer_Card_ID INT PRIMARY KEY,
  Customer_ID INT,
  FOREIGN KEY (Customer_ID) REFERENCES Personal_Information(Customer_ID)
);

-- Create the Transactions table
CREATE TABLE IF NOT EXISTS Transactions (
  Transaction_ID INT PRIMARY KEY,
  Customer_Card_ID INT,
  Transaction_Summ DECIMAL(10, 2),
  Transaction_DateTime TIMESTAMP,
  FOREIGN KEY (Customer_Card_ID) REFERENCES Cards(Customer_Card_ID)
);

-- Create the Checks table
CREATE TABLE IF NOT EXISTS Checks (
  Transaction_ID INT,
  SKU_ID INT,
  SKU_Amount INT,
  SKU_Summ DECIMAL(10, 2),
  SKU_Summ_Paid DECIMAL(10, 2),
  SKU_Discount DECIMAL(10, 2),
  FOREIGN KEY (Transaction_ID) REFERENCES Transactions(Transaction_ID)
);

-- Create the Product grid table
CREATE TABLE IF NOT EXISTS Product_Grid (
  SKU_ID INT PRIMARY KEY,
  SKU_Name VARCHAR(255),
  Group_ID INT,
  SKU_Purchase_Price DECIMAL(10, 2),
  SKU_Retail_Price DECIMAL(10, 2)
);

-- Create the Stores table
CREATE TABLE IF NOT EXISTS Stores (
  Store_ID INT PRIMARY KEY,  -- Изменили название поля на Store_ID
  Transaction_Store_ID INT,
  SKU_ID INT,
  SKU_Purchase_Price DECIMAL(10, 2),
  SKU_Retail_Price DECIMAL(10, 2),
  FOREIGN KEY (Transaction_Store_ID) REFERENCES Transactions(Transaction_ID)
);

-- Create the SKU group table
CREATE TABLE IF NOT EXISTS SKU_Group (
  Group_ID INT PRIMARY KEY,
  Group_Name VARCHAR(255)
);

-- Create the Date of analysis formation table
CREATE TABLE IF NOT EXISTS Date_of_Analysis_Formation (
  Analysis_Formation TIMESTAMP
);

-- Insert sample data into Personal Information table
INSERT INTO Personal_Information (Customer_ID, Customer_Name, Customer_Surname, Customer_Primary_Email, Customer_Primary_Phone)
VALUES (1, 'John', 'Doe', 'johndoe@example.com', '+79123456789'),
       (2, 'Jane', 'Smith', 'janesmith@example.com', '+79098765432'),
       (3, 'Michael', 'Johnson', 'michaeljohnson@example.com', '+79876543210'),
       (4, 'Emily', 'Davis', 'emilydavis@example.com', '+79785634120'),
       (5, 'David', 'Taylor', 'davidtaylor@example.com', '+79654321870');

-- Insert sample data into Cards table
INSERT INTO Cards (Customer_Card_ID, Customer_ID)
VALUES (101, 1),
       (102, 1),
       (103, 2),
       (104, 3),
       (105, 4);

-- Insert sample data into Transactions table
INSERT INTO Transactions (Transaction_ID, Customer_Card_ID, Transaction_Summ, Transaction_DateTime)
VALUES (1001, 101, 500.00, '2023-06-01 10:15:00'),
       (1002, 101, 100.00, '2023-06-03 14:30:00'),
       (1003, 102, 200.00, '2023-06-04 09:45:00'),
       (1004, 103, 150.00, '2023-06-05 16:20:00'),
       (1005, 104, 300.00, '2023-06-06 11:10:00');

-- Insert sample data into Checks table
INSERT INTO Checks (Transaction_ID, SKU_ID, SKU_Amount, SKU_Summ, SKU_Summ_Paid, SKU_Discount)
VALUES (1001, 1001, 2, 100.00, 100.00, 0.00),
       (1001, 1002, 1, 50.00, 50.00, 0.00),
       (1002, 1003, 1, 50.00, 50.00, 0.00),
       (1003, 1004, 1, 200.00, 200.00, 0.00),
       (1004, 1005, 2, 100.00, 100.00, 0.00);

-- Insert sample data into Product Grid table
INSERT INTO Product_Grid (SKU_ID, SKU_Name, Group_ID, SKU_Purchase_Price, SKU_Retail_Price)
VALUES (1001, 'Product 1', 1, 10.00, 15.00),
       (1002, 'Product 2', 1, 20.00, 30.00),
       (1003, 'Product 3', 2, 30.00, 45.00),
       (1004, 'Product 4', 2, 40.00, 60.00),
       (1005, 'Product 5', 3, 50.00, 75.00);

-- Insert sample data into Stores table
INSERT INTO Stores (Store_ID, Transaction_Store_ID, SKU_ID, SKU_Purchase_Price, SKU_Retail_Price)
VALUES (1, 1001, 1001, 9.50, 14.50),
       (2, 1001, 1002, 19.50, 29.50),
       (3, 1002, 1003, 29.50, 44.50),
       (4, 1002, 1004, 39.50, 59.50),
       (5, 1003, 1005, 49.50, 74.50);

-- Insert sample data into SKU Group table
INSERT INTO SKU_Group (Group_ID, Group_Name)
VALUES (1, 'Group 1'),
       (2, 'Group 2'),
       (3, 'Group 3');

-- Insert sample data into Date of Analysis Formation table
INSERT INTO Date_of_Analysis_Formation (Analysis_Formation)
VALUES ('2023-06-15 12:00:00');
