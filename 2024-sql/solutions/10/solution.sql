DROP VIEW IF EXISTS grid_bounds;
DROP TABLE IF EXISTS grid, directions;

CREATE TABLE grid (
        id SERIAL PRIMARY KEY
        , x INT NOT NULL
        , y INT NOT NULL
        , n INT NOT NULL
);

CREATE TABLE directions (
        x INT NOT NULL
        , y INT NOT NULL
);

INSERT INTO directions (x, y)
VALUES (1, 0), (0, 1), (-1, 0), (0, -1);

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
                        INSERT INTO grid (x, y, n) VALUES (x, y, c::INT);

                        x := x + 1;
                END LOOP;

                y := y + 1;
        END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT process_raw_data();

CREATE VIEW grid_bounds AS (
        SELECT
                0 AS min_x
                , 0 AS min_y
                , MAX(grid.x) AS max_x
                , MAX(grid.y) AS max_y
        FROM grid
);

WITH RECURSIVE bfs AS (
        SELECT
                id
                , x
                , y
                , n
                , x AS ox
                , y AS oy
        FROM grid
        WHERE n = 0

        UNION ALL

        SELECT
                g.id
                , g.x
                , g.y
                , g.n
                , b.ox
                , b.oy
        FROM bfs b
        CROSS JOIN directions d
        INNER JOIN grid g
                ON b.x + d.x = g.x
                AND b.y + d.y = g.y
                AND b.n + 1 = g.n
)
, part1 AS (
        SELECT
                1 AS part
                , COUNT(DISTINCT (x, y, ox, oy)) AS result
        FROM bfs
        WHERE n = 9
)
, part2 AS (
        SELECT
                2 AS part
                , COUNT(*) AS result
        FROM bfs
        WHERE n = 9
)

SELECT
        update_solution(10, results.part, results.result)
FROM (
        SELECT * FROM part1
        UNION ALL
        SELECT * FROM part2
) AS results;

DROP FUNCTION IF EXISTS
        process_raw_data;
DROP VIEW IF EXISTS
        grid_bounds;
DROP TABLE IF EXISTS
        raw_data
        , grid
        , directions;
