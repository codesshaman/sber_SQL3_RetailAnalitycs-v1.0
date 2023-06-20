CREATE DATABASE customer_data;

\c customer_data

CREATE TABLE Personal_Information (
  Customer_ID serial PRIMARY KEY,
  Customer_Name varchar(50) NOT NULL,
  Customer_Surname varchar(50) NOT NULL,
  Customer_Primary_Email varchar(100) NOT NULL,
  Customer_Primary_Phone varchar(12) NOT NULL
);

CREATE TABLE Cards (
  Customer_Card_ID serial PRIMARY KEY,
  Customer_ID int NOT NULL REFERENCES Personal_Information(Customer_ID)
);

CREATE TABLE Transactions (
  Transaction_ID serial PRIMARY KEY,
  Customer_Card_ID int NOT NULL REFERENCES Cards(Customer_Card_ID),
  Transaction_Summ numeric(10,2) NOT NULL,
  Transaction_DateTime timestamp NOT NULL,
  Transaction_Store_ID varchar(10) NOT NULL
);

CREATE TABLE Checks (
  SKU_ID int NOT NULL,
  Transaction_ID int NOT NULL REFERENCES Transactions(Transaction_ID),
  SKU_Amount numeric(10,2) NOT NULL,
  SKU_Summ numeric(10,2) NOT NULL,
  SKU_Summ_Paid numeric(10,2) NOT NULL,
  SKU_Discount numeric(10,2) NOT NULL,
  PRIMARY KEY (SKU_ID, Transaction_ID)
);

CREATE TABLE Product_Grid (
  SKU_ID serial PRIMARY KEY,
  SKU_Name varchar(50) NOT NULL,
  Group_ID int NOT NULL,
  SKU_Purchase_Price numeric(10,2) NOT NULL,
  SKU_Retail_Price numeric(10,2) NOT NULL
);

CREATE TABLE Stores (
  Transaction_Store_ID varchar(10) NOT NULL,
  SKU_ID int NOT NULL REFERENCES Product_Grid(SKU_ID),
  SKU_Purchase_Price numeric(10,2) NOT NULL,
  SKU_Retail_Price numeric(10,2) NOT NULL
);

CREATE TABLE SKU_Group (
  Group_ID serial PRIMARY KEY,
  Group_Name varchar(50) NOT NULL
);

CREATE TABLE Analysis_Formation_Date (
  Analysis_Formation timestamp NOT NULL PRIMARY KEY
);

-- Add test data to Personal_Information table
INSERT INTO Personal_Information (Customer_Name, Customer_Surname, Customer_Primary_Email, Customer_Primary_Phone)
VALUES 
('John', 'Doe', 'johndoe@gmail.com', '+79876543210'),
('Jane', 'Doe', 'janedoe@gmail.com', '+79123456789'),
('Bob', 'Smith', 'bob.smith@yahoo.com', '+79991234567'),
('Alice', 'Jones', 'alicejones@hotmail.com', '+79011234567'),
('Peter', 'Johnson', 'peterjohnson@gmail.com', '+79129567890');

-- Add test data to Cards table
INSERT INTO Cards (Customer_ID)
VALUES 
(1),
(1),
(2),
(3),
(4),
(5),
(5);

-- Add test data to Transactions table
INSERT INTO Transactions (Customer_Card_ID, Transaction_Summ, Transaction_DateTime, Transaction_Store_ID)
VALUES 
(1, 500.00, '2022-01-01 12:00:00', 'Store A'),
(2, 800.00, '2022-01-02 10:00:00', 'Store B'),
(3, 1500.00, '2022-01-03 15:00:00', 'Store A'),
(4, 2000.00, '2022-01-05 16:00:00', 'Store C'),
(5, 1000.00, '2022-01-06 09:00:00', 'Store B'),
(6, 1200.00, '2022-01-07 11:00:00', 'Store A'),
(7, 300.00, '2022-01-08 13:00:00', 'Store B');

-- Add test data to Checks table
INSERT INTO Checks (SKU_ID, Transaction_ID, SKU_Amount, SKU_Summ, SKU_Summ_Paid, SKU_Discount)
VALUES 
(1, 1, 1, 500.00, 500.00, 0),
(2, 2, 2, 800.00, 720.00, 80.00),
(3, 3, 1, 1500.00, 1500.00, 0),
(4, 4, 3, 2000.00, 1900.00, 100.00),
(5, 5, 1, 1000.00, 900.00, 100.00);