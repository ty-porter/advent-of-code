DROP TABLE IF EXISTS equations;

CREATE TABLE equations (
        id SERIAL PRIMARY KEY
        , tgt BIGINT NOT NULL
        , operands BIGINT[]
);

CREATE OR REPLACE FUNCTION process_raw_data()
RETURNS VOID AS $$
BEGIN
        WITH segments AS (
                SELECT
                        string_to_array(raw_data, ': ') AS seg_array
                FROM raw_data
        )
        , parsed_segments AS (
                SELECT 
                        seg_array[1]::BIGINT AS tgt
                        , ARRAY(
                                SELECT
                                        element::BIGINT
                                FROM unnest(string_to_array(seg_array[2], ' ')) AS element
                        ) AS operands
                FROM segments
        )
        INSERT INTO equations (tgt, operands)
        SELECT
                tgt, operands
        FROM parsed_segments;
END;
$$ LANGUAGE plpgsql;

SELECT process_raw_data();

WITH RECURSIVE bfs AS (
        SELECT
                eq.id
                , eq.tgt
                , eq.operands[1] AS current_val
                , eq.operands AS operands
                , 1 AS idx
        FROM equations eq

        UNION ALL

        SELECT
                b.id
                , b.tgt
                , CASE
                        WHEN op = '+' THEN b.current_val + b.operands[b.idx + 1]
                        WHEN op = '*' THEN b.current_val * b.operands[b.idx + 1]
                END AS current_val
                , b.operands
                , b.idx + 1
        FROM bfs b
        CROSS JOIN unnest(ARRAY['+', '*']) AS op
        WHERE b.idx < array_length(b.operands, 1)
)
, ranked AS (
        SELECT
                b.*
                , ROW_NUMBER() OVER (PARTITION BY b.id ORDER BY b.idx DESC) AS rank
        FROM bfs b
        WHERE b.current_val = b.tgt
)
, part1 AS (
        SELECT
                1 AS part
                , SUM(tgt) AS result
        FROM ranked
        WHERE rank = 1
)


SELECT
        update_solution(7, results.part, results.result)
FROM (
        SELECT * FROM part1
        -- UNION ALL
        -- SELECT * FROM part2
) AS results;

DROP FUNCTION IF EXISTS
        process_raw_data;
DROP TABLE IF EXISTS
        equations;
