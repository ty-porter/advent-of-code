DROP TABLE IF EXISTS stones, blink;

CREATE TABLE stones (
        stone BIGINT
        , frequency BIGINT NOT NULL DEFAULT 1
);

WITH raw_stones AS (
        SELECT
                unnest(string_to_array(rd.raw_data, ' ')) AS stone
        FROM raw_data rd
)
INSERT INTO stones (stone)
SELECT
        stone::BIGINT
FROM raw_stones;

CREATE OR REPLACE FUNCTION blink_stone(stone BIGINT)
RETURNS BIGINT[] AS $$
DECLARE
        blinked_stones BIGINT[] := '{}';
        l INT;
        strstone VARCHAR;
BEGIN
        strstone = stone::VARCHAR;
        l = length(strstone);

        IF stone = 0 THEN
                blinked_stones := blinked_stones || 1;
        ELSIF l % 2 = 0 THEN
                blinked_stones := blinked_stones || substr(strstone, 1, l / 2)::BIGINT;
                blinked_stones := blinked_stones || substr(strstone, l / 2 + 1, l)::BIGINT;
        ELSE
                blinked_stones := blinked_stones || stone * 2024;
        END IF;

        RETURN blinked_stones;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION blink_all(iterations INT)
RETURNS VOID AS $$
DECLARE
        i INT;
BEGIN
        CREATE TEMP TABLE work (
                stone BIGINT PRIMARY KEY
                , frequency BIGINT NOT NULL
        );

        FOR i IN 1..iterations
        LOOP
                WITH blinked AS (
                        SELECT
                                unnest(blink_stone(stone)) AS stone
                                , frequency
                        FROM blink
                )
                , updates AS (
                        SELECT
                                stone
                                , sum(frequency) AS frequency
                        FROM blinked
                        GROUP BY stone
                )
                INSERT INTO work (stone, frequency)
                SELECT * FROM updates;

                TRUNCATE TABLE blink;

                INSERT INTO blink (stone, frequency)
                SELECT * FROM work;

                TRUNCATE TABLE work;
        END LOOP;

        DROP TABLE work;
END;
$$ LANGUAGE plpgsql;

CREATE TABLE IF NOT EXISTS blink AS
SELECT * FROM stones;

-- Part 1
SELECT blink_all(25);

SELECT
        update_solution(11, 1, sum(frequency))
FROM blink;

-- Part 2
SELECT blink_all(50); -- Reuse the existing work set for (75 - 25) more iterations

SELECT
        update_solution(11, 2, sum(frequency))
FROM blink;

DROP FUNCTION IF EXISTS
        process_raw_data
        , blink_stone
        , blink_all;
DROP TABLE IF EXISTS
        raw_data
        , stones
        , blink;
