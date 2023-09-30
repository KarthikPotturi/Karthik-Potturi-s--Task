WITH PurchaseBuckets AS (
    SELECT
        c.cust_id,
        COUNT(DISTINCT p.purchase_id) AS total_purchases
    FROM
        cf_customer c
    LEFT JOIN
        cf_purchase p ON c.cust_id = p.cust_id
    GROUP BY
        c.cust_id
)
SELECT
    '0 purchase' AS ACCOUNT_PURCHASE_BUCKET,
    CAST(ROUND(CAST(COUNT(CASE WHEN total_purchases = 0 THEN 1 END) AS DECIMAL) / CAST(COUNT(*) AS DECIMAL) * 100, 2) AS INT) AS PERCENTAGE
FROM
    PurchaseBuckets
UNION ALL
SELECT
    '1-5 purchases' AS ACCOUNT_PURCHASE_BUCKET,
    CAST(ROUND(CAST(COUNT(CASE WHEN total_purchases BETWEEN 1 AND 5 THEN 1 END) AS DECIMAL) / CAST(COUNT(*) AS DECIMAL) * 100, 2) AS INT) AS PERCENTAGE
FROM
    PurchaseBuckets
UNION ALL
SELECT
    '6 or more purchases' AS ACCOUNT_PURCHASE_BUCKET,
    CAST(ROUND(CAST(COUNT(CASE WHEN total_purchases >= 6 THEN 1 END) AS DECIMAL) / CAST(COUNT(*) AS DECIMAL) * 100, 2) AS INT) AS PERCENTAGE
FROM
    PurchaseBuckets;
