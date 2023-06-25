CREATE OR REPLACE VIEW Periods AS
    WITH base AS (
        SELECT customer_id,
               group_id,
               min(transaction_datetime) AS First_Group_Purchase_Date,
               max(transaction_datetime) AS Last_Group_Purchase_Date,
               count(transaction_id) AS Group_Purchase
        FROM purchasehistory
        GROUP BY customer_id, group_id
    ), min_disc AS (
        SELECT customer_id,
               group_id,
               min(SKU_Discount/SKU_Summ) AS Min_Discount
        FROM purchasehistory ph
            JOIN checks c on ph.transaction_id = c.transaction_id
        WHERE SKU_Discount <> 0
        GROUP BY customer_id, group_id
        ORDER BY customer_id, group_id
    )
    SELECT DISTINCT
        b.customer_id,
        b.group_id,
        First_Group_Purchase_Date,
        Last_Group_Purchase_Date,
        Group_Purchase,
        (date_part('day', Last_Group_Purchase_Date - First_Group_Purchase_Date) + 1)::numeric / Group_Purchase  AS Group_Frequency,
        (CASE WHEN Min_Discount IS NULL THEN 0 ELSE Min_Discount END) AS Group_Min_Discount
    FROM base b
        JOIN purchasehistory ph ON ph.customer_id = b.customer_id AND ph.group_id = b.group_id
        JOIN checks c on ph.transaction_id = c.transaction_id
        FULL JOIN min_disc m_d ON m_d.customer_id = b.customer_id AND m_d.group_id = b.group_id;
