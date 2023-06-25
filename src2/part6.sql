CREATE OR REPLACE FUNCTION fun_cross_selling(groups_count integer, max_churn_index decimal, max_stability_index decimal,
                                            max_SKU_share decimal, margin_share decimal)
RETURNS table(Customer_ID bigint, SKU_Name varchar, Offer_Discount_Depth decimal)
AS $$
BEGIN
    RETURN QUERY
WITH p1 AS (
    SELECT gr.Customer_ID,
           Group_ID,
           row_number() OVER (PARTITION BY gr.Customer_ID, Group_ID ORDER BY Group_Affinity_Index DESC) AS pos
    FROM groups gr
    WHERE gr.Group_Churn_Rate <= max_churn_index
      AND group_stability_index < max_stability_index
    ORDER BY gr.Customer_ID, Group_ID
)    , p2 AS (
    SELECT *
    FROM p1
    WHERE pos <= groups_count
)
    , p3 AS (
    SELECT p2.Customer_ID,
           p2.Group_ID,
           max(SKU_Retail_Price::decimal - SKU_Purchase_Price::decimal)::decimal AS max_margin
    FROM p2
        JOIN productgrid pr ON p2.group_id = pr.group_id
        JOIN stores st ON pr.sku_id = st.sku_id
    GROUP BY p2.Customer_ID, p2.Group_ID
)
    , p4 AS (
    SELECT DISTINCT p3.Customer_ID,
           p3.Group_ID,
           p3.max_margin::decimal,
            count(c.transaction_id) OVER (PARTITION BY p3.Customer_ID, c.sku_id)  /
            count(c.transaction_id) OVER (PARTITION BY p3.Customer_ID, p3.Group_ID)::decimal AS Res
    FROM p3
       JOIN purchasehistory ph ON p3.group_id = ph.group_id AND p3.customer_id = ph.customer_id
       JOIN checks c on ph.transaction_id = c.transaction_id
)

 SELECT p4.Customer_ID,
        pr.sku_name,
        (CASE WHEN p4.max_margin * (margin_share / 100.0) / SKU_Retail_Price <= ceil(Group_Minimum_Discount * 100 / 5) * 5
            THEN ceil(Group_Minimum_Discount * 100 / 5) * 5 END) AS Offer_Discount_Depth
    FROM p4
        JOIN customers c ON p4.customer_id = c.customer_id
        JOIN groups g ON p4.customer_id = g.customer_id AND p4.group_id = g.group_id
       JOIN productgrid pr ON p4.group_id = pr.group_id
        JOIN stores st ON pr.sku_id = st.sku_id
                              AND st.transaction_store_id = c.customer_primary_store
    WHERE res <= max_SKU_share/100;

END
$$ LANGUAGE plpgsql;

SELECT * FROM fun_cross_selling(5, 3, 0.5,100,  30);