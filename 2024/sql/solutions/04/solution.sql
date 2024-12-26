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
        WITH xs_pairs AS MATERIALIZED (
                SELECT 
                        x.x
                        , x.y
                        , s.x AS sx
                        , s.y AS sy
                        , CASE WHEN s.x - x.x != 0
                                THEN abs(s.x - x.x) / (s.x - x.x)
                                ELSE 0
                        END AS dx
                        , CASE WHEN s.y - x.y != 0
                                THEN abs(s.y - x.y) / (s.y - x.y)
                                ELSE 0
                        END AS dy
                FROM crossword x
                CROSS JOIN LATERAL (
                        SELECT x + 3 AS sx, y AS sy
                        UNION ALL
                        SELECT x - 3 AS sx, y AS sy
                        UNION ALL
                        SELECT x AS sx, y + 3 AS sy
                        UNION ALL
                        SELECT x AS sx, y - 3 AS sy
                        UNION ALL
                        SELECT x + 3 AS sx, y + 3 AS sy
                        UNION ALL
                        SELECT x + 3 AS sx, y - 3 AS sy
                        UNION ALL
                        SELECT x - 3 AS sx, y + 3 AS sy
                        UNION ALL
                        SELECT x - 3 AS sx, y - 3 AS sy
                ) possible_positions
                INNER JOIN crossword s
                        ON possible_positions.sx = s.x AND possible_positions.sy = s.y
                WHERE x.letter = 'X' AND s.letter = 'S'
        )
        , xmas AS (
                SELECT 
                        x.*
                FROM xs_pairs x
                INNER JOIN crossword m 
                        ON x.x + x.dx = m.x
                        AND x.y + x.dy = m.y
                INNER JOIN crossword a
                        ON x.x + (2 * x.dx) = a.x
                        AND x.y + (2 * x.dy) = a.y
                WHERE m.letter = 'M' AND a.letter = 'A'
        )
        SELECT 
                1 AS part
                , COUNT(*) AS result
        FROM xmas
)
, part2 AS (
        WITH a AS (
                SELECT * FROM crossword WHERE letter = 'A'
        )
        , forward_diag AS MATERIALIZED (
                SELECT
                        a.id
                        , a.letter
                        , a.x
                        , a.y
                        , d.id as did
                        , d.letter AS dletter
                        , d.x AS dx
                        , d.y AS dy
                FROM a
                CROSS JOIN LATERAL (
                        SELECT a.x - 1 AS x, a.y + 1 AS y
                        UNION ALL
                        SELECT a.x + 1 AS x, a.y - 1 AS y
                ) diag
                INNER JOIN crossword d
                        ON diag.x = d.x
                        AND diag.y = d.y
                WHERE a.letter = 'A' AND d.letter in ('S', 'M')
        )
        , backward_diag AS MATERIALIZED (
                SELECT
                        a.id
                        , a.letter
                        , a.x
                        , a.y
                        , d.id as did
                        , d.letter AS dletter
                        , d.x AS dx
                        , d.y AS dy
                FROM a
                CROSS JOIN LATERAL (
                        SELECT a.x - 1 AS x, a.y - 1 AS y
                        UNION ALL
                        SELECT a.x + 1 AS x, a.y + 1 AS y
                ) diag
                INNER JOIN crossword d
                        ON diag.x = d.x
                        AND diag.y = d.y
                WHERE a.letter = 'A' AND d.letter in ('S', 'M')
        )
        , diags AS (
                SELECT
                        id
                        , SUM(letters) = 4 AS correct
                FROM (
                        SELECT
                                id
                                , COUNT(DISTINCT dletter) AS letters
                        FROM forward_diag
                        GROUP BY id
                        UNION ALL
                        SELECT
                                id
                                , COUNT(DISTINCT dletter) AS letters
                        FROM backward_diag
                        GROUP BY id
                ) AS letters
                GROUP BY id
        )
        , x_mas AS (
                SELECT
                        d.*
                FROM a
                INNER JOIN diags d on a.id = d.id
        )
        SELECT
                2 AS part
                , COUNT(*)
        FROM x_mas
        WHERE correct
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
