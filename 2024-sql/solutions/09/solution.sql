DROP TABLE IF EXISTS filesystem, defragged_fs CASCADE;

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

CREATE OR REPLACE FUNCTION defrag()
RETURNS VOID AS $$
DECLARE
        bid INT;
        bdsz INT;
        bid_start INT;
        range_start INT;
        range_end INT;
BEGIN
        SELECT
                max(f.block_id) INTO bid
        FROM filesystem f;

        FOR bid IN
                SELECT
                        DISTINCT(f.block_id)
                FROM filesystem f
                WHERE f.block_id != -1
                ORDER BY f.block_id DESC
        LOOP
                SELECT count(*) INTO bdsz FROM filesystem f WHERE f.block_id = bid;
                SELECT min(pos) INTO bid_start FROM filesystem f WHERE f.block_id = bid;

                SELECT
                        fr.range_start, fr.range_end
                INTO
                        range_start, range_end
                FROM free_ranges fr
                WHERE sz >= bdsz AND fr.range_end < bid_start
                ORDER BY fr.range_start ASC
                LIMIT 1;

                IF range_start IS NOT NULL THEN
                        UPDATE defragged_fs
                        SET block_id = -1
                        WHERE block_id = bid;

                        UPDATE defragged_fs
                        SET block_id = bid
                        WHERE pos BETWEEN range_start AND range_start + bdsz - 1;
                END IF;
        END LOOP;
END;
$$ LANGUAGE plpgsql;

CREATE TABLE defragged_fs AS
SELECT * FROM filesystem;

ALTER TABLE
        defragged_fs
ADD CONSTRAINT unique_defrag_pos
UNIQUE (pos);

CREATE OR REPLACE VIEW free_ranges AS (
        WITH consecutive_free AS (
                SELECT
                        DISTINCT(pos)
                        , block_id
                        , pos - ROW_NUMBER() OVER (ORDER BY pos) AS group_id
                FROM defragged_fs
                WHERE block_id = -1
        )
        , ranges AS (
                SELECT
                        min(pos) AS range_start
                        , max(pos) AS range_end
                FROM consecutive_free
                GROUP BY group_id
        )
        SELECT
                range_start
                , range_end
                , range_end - range_start + 1 AS sz
        FROM ranges
        ORDER BY range_start
);

SELECT defrag();

SELECT
        update_solution(9, 2, sum(pos * block_id))
FROM defragged_fs AS resuts
WHERE block_id >= 0;

DROP FUNCTION IF EXISTS
        process_raw_data
        , defrag;
DROP VIEW IF EXISTS
        free_ranges;
DROP TABLE IF EXISTS
        raw_data
        , filesystem
        , defragged_fs;
DROP SEQUENCE IF EXISTS
        fs_sequence;
