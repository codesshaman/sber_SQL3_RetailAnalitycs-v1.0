CREATE OR REPLACE VIEW Customers AS

WITH Avg_Check AS (
    SELECT Customer_ID, AVG(Transaction_Summ)::decimal as Customer_Average_Check
    FROM Cards c
        JOIN transactions t ON c.customer_card_id = t.customer_card_id
    GROUP BY Customer_ID
    ORDER BY Customer_Average_Check DESC
)
   , Avg_Check_Segment AS (
    SELECT *,
            CASE WHEN row_number() over (ORDER BY Customer_Average_Check desc) <= (SELECT round(count(*)*0.10) FROM Avg_Check) THEN 'High'
                WHEN row_number() over (ORDER BY Customer_Average_Check desc) > (SELECT round(count(*)*0.35) FROM Avg_Check) THEN 'Low'
                ELSE 'Medium'
            END as Customer_Average_Check_Segment
    FROM Avg_Check
    ORDER BY Customer_Average_Check DESC
)
   , Frequency AS (
    SELECT Customer_ID,
           EXTRACT(EPOCH FROM (max(Transaction_DateTime)-min(Transaction_DateTime)))/ 60 / 60 / 24/ count(Transaction_ID)::decimal
               AS Customer_Frequency
    FROM Cards c
        JOIN transactions t ON c.customer_card_id = t.customer_card_id
    GROUP BY Customer_ID
    ORDER BY Customer_Frequency
)
   , Frequency_Segment AS (
    SELECT *,
           CASE
               WHEN row_number() over (ORDER BY Customer_Frequency) <=
                    (SELECT round(count(*) * 0.10) FROM Frequency) THEN 'Often'
               WHEN row_number() over (ORDER BY Customer_Frequency) >
                    (SELECT round(count(*) * 0.35) FROM Frequency) THEN 'Rarely'
               ELSE 'Occasionally'
               END as Customer_Frequency_Segment
    FROM Frequency
    ORDER BY Customer_Frequency
)
   , Inactive_Period AS (
    SELECT Customer_ID,
           EXTRACT(EPOCH FROM (SELECT * FROM dateofanalysisformation)-max(Transaction_DateTime))::decimal/ 60 / 60 / 24
               AS Customer_Inactive_Period
    FROM Cards
        JOIN transactions ON cards.customer_card_id = transactions.customer_card_id
    GROUP BY Customer_ID
    ORDER BY Customer_Inactive_Period
)
   , Churn_Rate AS (
    SELECT i.customer_id, Customer_Inactive_Period,
           Customer_Inactive_Period/Customer_Frequency AS Customer_Churn_Rate
    FROM Inactive_Period i
        JOIN Frequency f ON i.customer_id = f.customer_id
    ORDER BY Customer_Churn_Rate
)
   , Churn_Segment AS (
    SELECT *,
           CASE
               WHEN Customer_Churn_Rate <= 2 THEN 'Low'
               WHEN Customer_Churn_Rate > 5 THEN 'High'
               ELSE 'Medium'
               END AS Customer_Churn_Segment
    FROM Churn_Rate
    ORDER BY Customer_Churn_Rate
)
   , Segments AS (
    SELECT avg.customer_id, Customer_Average_Check_Segment, Customer_Frequency_Segment, Customer_Churn_Segment,
           (CASE
               WHEN Customer_Average_Check_Segment ='Low'  THEN 0
               WHEN Customer_Average_Check_Segment ='Medium'  THEN 1
               WHEN Customer_Average_Check_Segment ='High'  THEN 2
           END * 9 +
           CASE
               WHEN Customer_Frequency_Segment = 'Rarely' THEN 0
               WHEN Customer_Frequency_Segment = 'Occasionally' THEN 1
               WHEN Customer_Frequency_Segment = 'Often' THEN 2
           END * 3 +
           CASE
               WHEN Customer_Churn_Segment = 'Low' THEN 0
               WHEN Customer_Churn_Segment = 'Medium' THEN 1
               WHEN Customer_Churn_Segment = 'High' THEN 2
           END + 1) AS Customer_Segment
    FROM Avg_Check_Segment avg
    JOIN Frequency_Segment fr ON fr.customer_id = avg.customer_id
    JOIN Churn_Segment ch ON ch.customer_id = avg.customer_id
)
   , Primary_Store_by_largest_share AS (
    SELECT DISTINCT ON (Customer_ID) customer_id, transaction_store_id AS Customer_Primary_Store, Transaction_DateTime,
            (count(transaction_store_id) over (partition by customer_id, transaction_store_id))/
            (count(transaction_id) over (partition by customer_id))::decimal AS part_transactions_in_store
    FROM Cards c
         JOIN transactions t ON c.customer_card_id = t.customer_card_id
    ORDER BY Customer_ID, part_transactions_in_store DESC, Transaction_DateTime DESC
)
   , Primary_Store_by_last_3_transactions AS (
   SELECT Customer_ID, Transaction_Store_ID AS Customer_Primary_Store
    FROM (
        SELECT Customer_ID, Transaction_Store_ID, Transaction_DateTime,
               row_number() OVER (PARTITION BY Customer_ID ORDER BY Transaction_DateTime DESC) AS pos
        FROM Cards c
            JOIN transactions t ON c.customer_card_id = t.customer_card_id) AS s1
    WHERE pos < 4
    GROUP BY Customer_ID, Transaction_Store_ID
        HAVING COUNT(*) = 3
)
   , Primary_Store AS ( --check_currect
    (SELECT Customer_ID, Customer_Primary_Store FROM Primary_Store_by_largest_share
    EXCEPT
    SELECT Customer_ID, Customer_Primary_Store FROM Primary_Store_by_last_3_transactions)
    UNION
    SELECT Customer_ID, Customer_Primary_Store FROM Primary_Store_by_largest_share
    ORDER BY Customer_ID
)

SELECT pr.Customer_ID,
       Customer_Average_Check,
       avg.Customer_Average_Check_Segment,
       Customer_Frequency,
       fr.Customer_Frequency_Segment,
       Customer_Inactive_Period,
       Customer_Churn_Rate,
       ch.Customer_Churn_Segment,
       Customer_Segment,
       Customer_Primary_Store
FROM Primary_Store pr
    JOIN Avg_Check_Segment avg ON pr.customer_id = avg.customer_id
    JOIN Frequency_Segment fr ON pr.customer_id = fr.customer_id
    JOIN Churn_Segment ch ON ch.customer_id = pr.customer_id
    JOIN Segments ON Segments.customer_id = pr.customer_id
ORDER BY Customer_ID
