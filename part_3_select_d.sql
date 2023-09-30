/*--------------*/	
Approach - 1
/*--------------*/
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
    food,
    total_quantity
FROM
    RankedProducts
WHERE
    rn = 3;
	
/*--------------*/	
Approach - 2
/*--------------*/
SELECT 
	b.name, 
	SUM(a.qty)TotalQty 
FROM 
	cf_purchases_line_item a 
JOIN 
	cf_product b
ON a.pid = b.pid
GROUP BY b.name
ORDER BY SUM(a.qty) DESC
OFFSET 2 ROWS
FETCH NEXT 1 ROW ONLY