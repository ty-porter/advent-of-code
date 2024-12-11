DROP TABLE IF EXISTS filesystem;

CREATE SEQUENCE IF NOT EXISTS fs_sequence START 1;

CREATE TABLE filesystem (
        pos INT DEFAULT nextval('fs_sequence') - 1 PRIMARY KEY
        , block_id INT NOT NULL
);

CREATE OR REPLACE FUNCTION process_raw_data()
RETURNS VOID AS $$
DECLARE
        block_id INT := 0;
        block_size INT;
        free_size INT;
        i INT;
        pair RECORD;
BEGIN
        FOR pair IN
        (
                SELECT
                        CASE
                                WHEN length(rd.raw_data) % 2 = 1 AND series.i = length(rd.raw_data)
                                THEN substr(rd.raw_data || '0', series.i, 2)
                                ELSE substr(rd.raw_data, series.i, 2)
                        END AS pair
                FROM raw_data rd,
                        generate_series(1, length(rd.raw_data), 2) AS series(i)
        )
        LOOP
                block_size := substr(pair.pair, 1, 1)::INT;
                free_size := substr(pair.pair, 2, 1)::INT;

                FOR i IN 1..block_size LOOP
                        INSERT INTO filesystem (block_id)
                        VALUES (block_id);
                END LOOP;

                block_id := block_id + 1;

                FOR i IN 1..free_size LOOP
                        INSERT INTO filesystem (block_id)
                        VALUES (-1);
                END LOOP;
        END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT process_raw_data();

WITH part1 AS (
        WITH max_block AS (
                SELECT
                        max(pos) AS pos
                FROM filesystem
                WHERE block_id != -1
        )
        , free_blocks AS (
                SELECT
                        f.pos
                        , ROW_NUMBER() OVER () AS rank
                FROM filesystem f
                WHERE f.block_id = -1
                        AND f.pos < (SELECT pos FROM max_block)
                ORDER BY f.pos ASC
        )
        , swappable AS (
                SELECT
                        b.*
                        , ROW_NUMBER() OVER () AS rank
                FROM filesystem b
                WHERE b.block_id != -1
                ORDER BY b.pos DESC
        )
        , final_size AS (
                SELECT
                        (SELECT pos FROM max_block) - (SELECT count(*) FROM free_blocks) + 1 AS sz
                FROM filesystem
                LIMIT 1
        )
        , swapped AS (
                SELECT
                        f.pos AS pos
                        , b.block_id AS block_id
                FROM swappable b
                INNER JOIN free_blocks f
                        ON f.rank = b.rank

                UNION ALL

                SELECT
                        *
                FROM filesystem
                WHERE block_id != -1
        )
        , scores AS (
                SELECT
                        block_id * pos AS score
                FROM swapped
                ORDER BY pos
                LIMIT (SELECT * FROM final_size)
        )

        SELECT
                1 AS part
                , sum(score) AS result
        FROM scores
)

SELECT update_solution(9, results.part, results.result) FROM part1 results;
SELECT update_solution(9, 2, '<SKIPPED>'::TEXT);

DROP FUNCTION IF EXISTS
        process_raw_data;
DROP TABLE IF EXISTS
        raw_data
        , filesystem;
DROP SEQUENCE IF EXISTS
        fs_sequence;
