CREATE OR REPLACE FUNCTION fun_increase_freq_visits(first_date timestamp, last_date timestamp, add_transactions integer,
                                                    max_churn_rate decimal, max_discount_share decimal, margin_share decimal)
RETURNS table(Customer_ID bigint, Start_Date timestamp, End_Date timestamp,
                Required_Transactions_Count decimal,  Group_Name varchar, Offer_Discount_Depth decimal)
AS $$
    DECLARE
        period decimal;
    BEGIN
        period := EXTRACT(EPOCH FROM (last_date-first_date))::decimal / 60 / 60 / 24;
    RETURN QUERY
    WITH suitable_groups AS (
        SELECT *
        FROM groups gr
        WHERE gr.Group_Churn_Rate <= 3 AND Group_Discount_Share < 70 / 100.0
        ORDER BY gr.Group_Affinity_Index DESC
    )
    SELECT DISTINCT
           c.Customer_ID,
           first_date Start_Date,
           last_date AS End_Date,
           round(period / Customer_Frequency::decimal) + add_transactions AS Required_Transactions_Count,
           dd.groupname,
           dd.offer_discount_depth
    FROM customers c
        JOIN suitable_groups s_gr ON c.customer_id = s_gr.customer_id
        JOIN skugroup sku ON s_gr.group_id = sku.group_id
        join fk_determinegroupanddiscount(max_churn_rate, max_discount_share,
            margin_share) dd ON dd.customer_id = c.Customer_ID
    ORDER BY c.Customer_ID;
    END
$$ LANGUAGE plpgsql;

SELECT * FROM fun_increase_freq_visits('2022-08-18 00:00:00', '2022-08-18 00:00:00',
    1,3, 70, 30);
