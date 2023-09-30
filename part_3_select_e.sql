WITH LoginCounts AS (
    SELECT
        DATENAME(WEEKDAY, create_date) AS day_of_week,
        COUNT(*) AS login_count,
        ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) AS rn
    FROM
        cf_login_history
	where login_status = 'Y'
    GROUP BY
        DATENAME(WEEKDAY, create_date)
)
SELECT
    day_of_week,
    login_count AS total_quantity
FROM
    LoginCounts
WHERE
    rn = 1

UNION ALL

SELECT
    day_of_week,
    login_count AS total_quantity
FROM
    LoginCounts
WHERE
    rn > 1 AND login_count = (SELECT TOP 1 login_count FROM LoginCounts WHERE rn = 1);