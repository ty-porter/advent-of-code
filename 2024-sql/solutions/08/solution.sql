DROP TABLE IF EXISTS grid;

CREATE TABLE grid (
        id SERIAL PRIMARY KEY
        , x INT NOT NULL
        , y INT NOT NULL
        , c VARCHAR NOT NULL
        , antennae BOOLEAN NOT NULL DEFAULT false
);

CREATE OR REPLACE FUNCTION process_raw_data()
RETURNS VOID AS $$
DECLARE
        record RECORD;
        x INT := 0;
        y INT := 0;
        c VARCHAR;
        char_row VARCHAR[];
BEGIN
        FOR record IN SELECT * FROM raw_data ORDER BY position ASC
        LOOP
                char_row := string_to_array(record.raw_data, NULL);
                x := 0;

                FOREACH c IN ARRAY char_row
                LOOP
                        INSERT INTO grid (x, y, c) VALUES (x, y, c);

                        x := x + 1;
                END LOOP;

                y := y + 1;
        END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT process_raw_data();

WITH grid_bounds AS (
        SELECT
                0 AS min_x
                , 0 AS min_y
                , MAX(grid.x) AS max_x
                , MAX(grid.y) AS max_y
        FROM grid
) 
, antennae_pairs AS (
        SELECT
                a1.x as a1x
                , a1.y as a1y
                , a2.x as a2x
                , a2.y as a2y
                , a1.c
        FROM grid a1
        JOIN grid a2
                ON a1.c != '.'
                AND a1.c = a2.c
                AND a1.id != a2.id
)
, antinodes AS (
        SELECT
                a1x + (a1x - a2x) AS x
                , a1y + (a1y - a2y) AS y
        FROM antennae_pairs

        UNION ALL

        SELECT
                a2x + (a2x - a1x) AS x
                , a2y + (a2y - a1y) AS y
        FROM antennae_pairs
)
SELECT
        update_solution(8, 1, count(distinct(x, y)))
FROM antinodes a
JOIN grid_bounds bounds
        on bounds.min_x <= a.x AND bounds.min_y <= a.y
        AND bounds.max_x >= a.x AND bounds.max_y >= a.y;

DROP FUNCTION IF EXISTS
        process_raw_data;
DROP TABLE IF EXISTS
        grid;