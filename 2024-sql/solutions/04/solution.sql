DROP TABLE IF EXISTS crossword;

CREATE TABLE crossword (
        id SERIAL PRIMARY KEY
        , x INT NOT NULL
        , y INT NOT NULL
        , letter CHAR NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_crossword_x_y ON crossword (x, y);
CREATE INDEX IF NOT EXISTS idx_crossword_letter_x_y ON crossword (letter, x, y);

CREATE OR REPLACE FUNCTION process_raw_data()
RETURNS VOID AS $$
DECLARE
        rec RECORD;
        pos INT;
        letter CHAR;
BEGIN
        FOR rec IN SELECT * FROM raw_data
        LOOP
                pos := 0;

                FOR letter IN SELECT unnest(string_to_array(rec.raw_data, NULL))
                LOOP
                        INSERT INTO crossword(x, y, letter)
                        VALUES (pos, rec.position - 1, letter);

                        pos := pos + 1;
                END LOOP;
        END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT process_raw_data();

WITH part1 AS (
        WITH xm AS (
                SELECT x.x AS xx, x.y AS xy, m.x AS mx, m.y AS my FROM crossword x
                INNER JOIN crossword m ON abs(x.x - m.x) <= 1 AND abs(x.y - m.y) <= 1
                WHERE x.letter = 'X' AND m.letter = 'M'
        )
        , xmas AS (
                SELECT 
                        EXISTS(
                                SELECT 1 FROM crossword a
                                WHERE a.letter = 'A'
                                        AND xm.mx - xm.xx = a.x - xm.mx AND xm.my - xm.xy = a.y - xm.my
                                LIMIT 1
                        )
                        AND
                        EXISTS(
                                SELECT 1 FROM crossword s
                                WHERE s.letter = 'S'
                                        AND (xm.mx - xm.xx) * 2 = s.x - xm.mx AND (xm.my - xm.xy) * 2 = s.y - xm.my
                                LIMIT 1
                        ) AS found
                FROM xm
        )
        SELECT
                1 AS part
                , COUNT(*) AS result
        FROM xmas
        WHERE found = true
)
, part2 AS (
        SELECT
                2 AS part
                , 0 AS result
)

SELECT
        update_solution(4, results.part, results.result)
FROM (
        SELECT * FROM part1
        UNION ALL
        SELECT * FROM part2
) AS results;

DROP TABLE IF EXISTS
        raw_data
        , crossword;
DROP FUNCTION IF EXISTS
        process_raw_data;
DROP INDEX IF EXISTS
        idx_crossword_x_y
        , idx_crossword_letter_x_y;