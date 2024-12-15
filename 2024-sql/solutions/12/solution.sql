DROP TABLE IF EXISTS grid;

CREATE TABLE grid (
        id SERIAL PRIMARY KEY
        , x INT NOT NULL
        , y INT NOT NULL
        , c VARCHAR NOT NULL
        , region_id INT
);
 
CREATE INDEX grid_id on grid (id);
CREATE INDEX grid_region ON grid (region_id);
CREATE INDEX grid_position on grid (x, y);

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

CREATE OR REPLACE FUNCTION define_regions()
RETURNS VOID AS $$
DECLARE
        rid INT := 1;
        region_start INT;
        rows_updated INT;
BEGIN
        WHILE (SELECT count(*) FROM grid WHERE region_id IS NULL) > 0 LOOP
                SELECT min(id) INTO region_start FROM grid WHERE region_id IS NULL;

                UPDATE grid
                SET region_id = rid
                WHERE id = region_start;

                LOOP
                        WITH adjacent AS (
                                SELECT
                                        adj.id
                                FROM grid base
                                INNER JOIN grid adj
                                        ON base.c = adj.c
                                WHERE base.region_id = rid
                                        AND adj.region_id IS NULL
                                        AND base.c = adj.c
                                        AND (abs(base.x - adj.x) + abs(base.y - adj.y)) = 1
                        )
                        UPDATE grid
                        SET region_id = rid
                        WHERE id IN (SELECT a.id FROM adjacent a);

                        GET DIAGNOSTICS rows_updated = ROW_COUNT;
                        IF rows_updated = 0 THEN
                                EXIT;
                        END IF;
                END LOOP;

                rid := rid + 1;
        END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT define_regions();

WITH area AS (
        SELECT
                region_id
                , count(*) AS area
        FROM grid
        GROUP BY region_id
)
, perimeter AS (
        WITH perimeters AS (
                SELECT
                        p.region_id
                        , (
                                SELECT count(*)
                                FROM grid g
                                WHERE p.c = g.c
                                        AND (ABS(p.x - g.x) + ABS(p.y - g.y)) = 1
                        ) AS neighbors
                 FROM grid p
        )
        SELECT
                region_id
                , sum(4 - neighbors) AS perimeter
        FROM perimeters
        GROUP BY region_id
)
, cost AS (
        SELECT
                r.region_id
                , (SELECT a.area FROM area a WHERE a.region_id = r.region_id) AS area
                , (SELECt p.perimeter FROM perimeter p WHERE p.region_id = r.region_id) AS perimeter
        FROM grid r
        GROUP BY r.region_id
)
, part1 AS (
        SELECT
                1 AS part
                , sum(area * perimeter) AS result
        FROM cost
)
-- , part2 AS (
        
-- )

SELECT
        update_solution(12, results.part, results.result)
FROM (
        SELECT * FROM part1
        -- UNION ALL
        -- SELECT * FROM part2
) AS results;

DROP FUNCTION
        process_raw_data,
        define_regions;
DROP TABLE
        grid;
