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

CREATE OR REPLACE FUNCTION find_sides(rid INT)
RETURNS INT AS $$
DECLARE
        -- bounding box
        x1 INT;
        y1 INT;
        x2 INT;
        y2 INT;

        -- iterators
        xi INT;
        yi INT;

        -- neighbor counting
        in_region BOOLEAN;
        neighbors BIT(8);
        cardinal_neighbors BIT(4);
        n_count INT;

        -- corner counting
        cell_corners INT;
        corners INT := 0;
BEGIN
        -- Define the region's bounding box
        SELECT min(x), min(y), max(x), max(y) INTO x1, y1, x2, y2 FROM grid WHERE region_id = rid;

        -- Iterate over cells in the bounding box and check for corners
        FOR yi IN y1..y2
        LOOP
                FOR xi IN x1..x2
                LOOP
                        SELECT true INTO in_region FROM grid WHERE x = xi AND y = yi AND region_id = rid;

                        cell_corners := 0;

                        WITH adjacent_cells AS (
                                SELECT
                                        ord, x, y
                                FROM (
                                        VALUES
                                        (1, xi    , yi - 1),  -- Up
                                        (2, xi + 1, yi    ),  -- Right
                                        (3, xi    , yi + 1),  -- Down
                                        (4, xi - 1, yi    ),  -- Left
                                        (5, xi + 1, yi - 1),  -- Up-Right
                                        (6, xi + 1, yi + 1),  -- Down-Right
                                        (7, xi - 1, yi + 1),  -- Down-Left
                                        (8, xi - 1, yi - 1)   -- Up-Left
                                ) AS adjacent(ord, x, y)
                        )
                        , ordered_cells AS ( 
                                SELECT
                                        ac.*
                                        , CASE
                                                WHEN g.id IS NOT NULL THEN '1'
                                                ELSE '0'
                                        END AS val
                                FROM adjacent_cells ac
                                LEFT JOIN grid g
                                        ON g.x = ac.x AND g.y = ac.y AND g.region_id = rid
                                ORDER BY ac.ord ASC
                        )
                        SELECT
                                string_agg(oc.val, '') AS bitmask
                        INTO
                                neighbors
                        FROM ordered_cells oc;

                        IF in_region THEN -- Handle external corners
                                -- Casting to BIT(4) from BIT(8) preserves the highest 4 bits??
                                cardinal_neighbors := neighbors::BIT(4);

                                n_count := 0;

                                FOR n IN 0..3
                                LOOP
                                        n_count := n_count + ((cardinal_neighbors::INT >> n) & 1)::INT;
                                END LOOP;

                                IF n_count = 0 THEN
                                        cell_corners := 4;
                                ELSIF n_count = 1 THEN
                                        cell_corners := 2;
                                ELSIF n_count = 2 THEN
                                        -- Use the bitmask to detect which permutations of neighbors we have
                                        IF cardinal_neighbors = ANY(ARRAY[3::BIT(4), 6::BIT(4), 9::BIT(4), 12::BIT(4)]) THEN
                                                cell_corners := 1;
                                        END IF;
                                END IF;

                        ELSE -- Handle internal corners
                                -- More bitmask tricks. Looking for 3 neighbors in an L-shape (i.e. up, right, up-right)
                                -- Bottom left (left / down / down-left)
                                IF neighbors & 50::BIT(8) = 50::BIT(8) THEN
                                        cell_corners := cell_corners + 1;
                                END IF;
                                -- Bottom right (right / down / down-right)
                                IF neighbors & 100::BIT(8) = 100::BIT(8) THEN
                                        cell_corners := cell_corners + 1;
                                END IF;
                                -- Top left (left / up / down-left)
                                IF neighbors & 145::BIT(8) = 145::BIT(8) THEN
                                        cell_corners := cell_corners + 1;
                                END IF;
                                -- Top right (right / up / down-right)
                                IF neighbors & 200::BIT(8) = 200::BIT(8) THEN
                                        cell_corners := cell_corners + 1;
                                END IF;
                        END IF;

                        corners := corners + cell_corners;
                END LOOP;
        END LOOP;

        RETURN corners;
END;
$$ LANGUAGE plpgsql;

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
, sides AS (
        WITH distinct_regions AS (
                SELECT
                        DISTINCT region_id
                FROM grid
        )
        SELECT
                region_id
                , find_sides(region_id) AS sides
        FROM distinct_regions
)
, cost AS (
        SELECT
                r.region_id
                , r.c
                , (SELECT a.area FROM area a WHERE a.region_id = r.region_id) AS area
                , (SELECT p.perimeter FROM perimeter p WHERE p.region_id = r.region_id) AS perimeter
        FROM grid r
        GROUP BY r.region_id, r.c
)
, cost_with_sides AS (
        SELECT
                c.*
                , s.sides
        FROM cost c
        INNER JOIN sides s ON c.region_id = s.region_id
)
, part1 AS (
        SELECT
                1 AS part
                , sum(area * perimeter) AS result
        FROM cost
)
, part2 AS (
        SELECT
                2 AS part
                , sum(area * sides) AS result
        FROM cost_with_sides
)

SELECT
        update_solution(12, results.part, results.result)
FROM (
        SELECT * FROM part1
        UNION ALL
        SELECT * FROM part2
) AS results;

DROP FUNCTION
        process_raw_data
        , define_regions
        , find_sides;
DROP TABLE
        grid;
