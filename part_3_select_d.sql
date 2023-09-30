WITH RankedProducts AS (
    SELECT
        name AS food,
        SUM(qty) AS total_quantity,
        ROW_NUMBER() OVER (ORDER BY SUM(qty) DESC) AS rn
    FROM
        cf_purchases_line_item
    GROUP BY
         name
)
SELECT
    FOOD,
    TOTAL_QUANTITY
FROM
    RankedProducts
WHERE
    rn = 3;
