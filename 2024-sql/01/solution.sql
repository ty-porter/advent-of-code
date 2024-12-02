DROP TABLE IF EXISTS lists;

CREATE TABLE lists (
        position SERIAL,
        value INT,
        list_id INT,
        PRIMARY KEY (position, list_id)
);

CREATE OR REPLACE FUNCTION process_raw_data()
RETURNS VOID AS $$
DECLARE
        rec RECORD;
        lvalue INT;
        rvalue INT;
BEGIN
        FOR rec IN SELECT raw_data.position, raw_data.raw_data FROM raw_data
        LOOP
                lvalue := (split_part(rec.raw_data, '   ', 1))::INT;
                rvalue := (split_part(rec.raw_data, '   ', 2))::INT;

                INSERT INTO lists (position, value, list_id)
                VALUES (rec.position, lvalue, 1), (rec.position, rvalue, 2);
        END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT process_raw_data();

WITH part1 AS (
        WITH sorted_l1 AS (
                SELECT
                        value
                        , ROW_NUMBER() OVER (ORDER BY value ASC) as rn
                FROM lists
                WHERE list_id = 1
                ORDER BY value ASC
        )
        , sorted_l2 AS (
                SELECT
                        value
                        , ROW_NUMBER() OVER (ORDER BY value ASC) as rn
                FROM lists
                WHERE list_id = 2
                ORDER BY value ASC
        )
        SELECT
                1 AS part
                , SUM(ABS(l1.value - l2.value)) AS result
                FROM sorted_l1 l1
                INNER JOIN sorted_l2 l2 on l1.rn = l2.rn
)
, part2 AS (
        SELECT
                2 AS part
                , SUM(
                        l1.value * 
                        (
                                SELECT
                                        COUNT(*) 
                                FROM lists l2
                                WHERE l2.list_id = 2
                                AND l2.value = l1.value
                        )
                ) AS result
        FROM lists l1
        WHERE l1.list_id = 1
        LIMIT 1
)

SELECT * FROM part1
UNION ALL
SELECT * FROM part2
ORDER BY part;

DROP TABLE IF EXISTS raw_data, lists;
DROP FUNCTION IF EXISTS process_raw_data;