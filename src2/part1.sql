CREATE TABLE IF NOT EXISTS PersonInformation(
    Customer_ID bigint primary key NOT NULL,
    Customer_Name varchar NOT NULL CHECK (Customer_Name SIMILAR TO '[A-ZА-ЯЁ][a-zа-яё\- ]*'),
    Customer_Surname varchar NOT NULL CHECK (Customer_Surname SIMILAR TO '[A-ZА-ЯЁ][a-zа-яё\- ]*'),
    Customer_Primary_Email varchar NOT NULL CHECK (Customer_Primary_Email SIMILAR TO '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}'),
    Customer_Primary_Phone varchar NOT NULL CHECK (Customer_Primary_Phone SIMILAR TO '\+7[0-9]{10}')
);

CREATE TABLE IF NOT EXISTS Cards(
    Customer_Card_ID bigint primary key NOT NULL,
    Customer_ID bigint NOT NULL references PersonInformation(Customer_ID)
);

CREATE TABLE IF NOT EXISTS SKUGroup(
    Group_ID bigint NOT NULL primary key,
    Group_Name varchar NOT NULL CHECK (Group_Name SIMILAR TO '[A-ZА-ЯЁa-zа-яё0-9\s\-\.,:;!?"()$@%#&*+=/\\]+')
);

CREATE TABLE IF NOT EXISTS ProductGrid(
    SKU_ID bigint NOT NULL primary key,
    SKU_Name varchar NOT NULL CHECK (SKU_Name SIMILAR TO '[A-ZА-ЯЁa-zа-яё0-9\s\-\.,:;!?"()$@%#&*+=/\\]+'),
    Group_ID bigint NOT NULL references SKUGroup(Group_ID)
);

CREATE TABLE IF NOT EXISTS Stores(
    Transaction_Store_ID bigint NOT NULL,
    SKU_ID bigint NOT NULL references ProductGrid(SKU_ID),
    SKU_Purchase_Price numeric NOT NULL,
    SKU_Retail_Price numeric NOT NULL
);

CREATE TABLE IF NOT EXISTS Transactions(
    Transaction_ID bigint NOT NULL primary key,
    Customer_Card_ID bigint NOT NULL references Cards(Customer_Card_ID),
    Transaction_Summ numeric NOT NULL,
    Transaction_DateTime timestamp NOT NULL CHECK (to_char(Transaction_DateTime, 'DD.MM.YYYY HH24:MI:SS'::text) SIMILAR TO '[0-9]{2}\.[0-9]{2}\.[0-9]{4} [0-9]{2}:[0-9]{2}:[0-9]{2}'),
    Transaction_Store_ID bigint NOT NULL
);

CREATE TABLE IF NOT EXISTS Checks(
    Transaction_ID bigint NOT NULL references Transactions(Transaction_ID),
    SKU_ID bigint NOT NULL references ProductGrid(SKU_ID),
    SKU_Amount numeric NOT NULL,
    SKU_Summ numeric NOT NULL,
    SKU_Summ_Paid numeric NOT NULL,
    SKU_Discount numeric NOT NULL
);

CREATE TABLE IF NOT EXISTS DateOfAnalysisFormation(
    Analysis_Formation timestamp NOT NULL  CHECK (to_char(Analysis_Formation, 'DD.MM.YYYY HH24:MI:SS'::text) SIMILAR TO '[0-9]{2}\.[0-9]{2}\.[0-9]{4} [0-9]{2}:[0-9]{2}:[0-9]{2}')
);

CREATE PROCEDURE prc_dataImport(t VARCHAR, path VARCHAR, delimit VARCHAR)
LANGUAGE plpgsql AS $$
    BEGIN
        EXECUTE FORMAT('COPY %s FROM %L WITH DELIMITER %L CSV;', t, path, delimit);
    END;
$$;

SET datestyle TO dmy;

-- CALL prc_dataImport('PersonInformation', '/Users/stevenso/SQL3_RetailAnalitycs_v1.0-1/datasets/Personal_Data_Mini.tsv', E'\t');
-- CALL prc_dataImport('Cards', '/Users/stevenso/SQL3_RetailAnalitycs_v1.0-1/datasets/Cards_Mini.tsv', E'\t');
-- CALL prc_dataImport('SKUGroup', '/Users/stevenso/SQL3_RetailAnalitycs_v1.0-1/datasets/Groups_SKU_Mini.tsv', E'\t');
-- CALL prc_dataImport('ProductGrid', '/Users/stevenso/SQL3_RetailAnalitycs_v1.0-1/datasets/SKU_Mini.tsv', E'\t');
-- CALL prc_dataImport('Stores', '/Users/stevenso/SQL3_RetailAnalitycs_v1.0-1/datasets/Stores_Mini.tsv', E'\t');
-- CALL prc_dataImport('Transactions', '/Users/stevenso/SQL3_RetailAnalitycs_v1.0-1/datasets/Transactions_Mini.tsv', E'\t');
-- CALL prc_dataImport('Checks', '/Users/stevenso/SQL3_RetailAnalitycs_v1.0-1/datasets/Checks_Mini.tsv', E'\t');
-- CALL prc_dataImport('DateOfAnalysisFormation', '/Users/stevenso/SQL3_RetailAnalitycs_v1.0-1/datasets/Date_Of_Analysis_Formation.tsv', E'\t');

-- CALL prc_dataImport('PersonInformation', '/Users/stevenso/SQL3_RetailAnalitycs_v1.0-1/datasets/Personal_Data.tsv', E'\t');
-- CALL prc_dataImport('Cards', '/Users/stevenso/SQL3_RetailAnalitycs_v1.0-1/datasets/Cards.tsv', E'\t');
-- CALL prc_dataImport('SKUGroup', '/Users/stevenso/SQL3_RetailAnalitycs_v1.0-1/datasets/Groups_SKU.tsv', E'\t');
-- CALL prc_dataImport('ProductGrid', '/Users/stevenso/SQL3_RetailAnalitycs_v1.0-1/datasets/SKU.tsv', E'\t');
-- CALL prc_dataImport('Stores', '/Users/stevenso/SQL3_RetailAnalitycs_v1.0-1/datasets/Stores.tsv', E'\t');
-- CALL prc_dataImport('Transactions', '/Users/stevenso/SQL3_RetailAnalitycs_v1.0-1/datasets/Transactions.tsv', E'\t');
-- CALL prc_dataImport('Checks', '/Users/stevenso/SQL3_RetailAnalitycs_v1.0-1/datasets/Checks.tsv', E'\t');
-- CALL prc_dataImport('DateOfAnalysisFormation', '/Users/stevenso/SQL3_RetailAnalitycs_v1.0-1/datasets/Date_Of_Analysis_Formation.tsv', E'\t');
