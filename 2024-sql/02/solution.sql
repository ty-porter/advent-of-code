DROP TABLE IF EXISTS reports CASCADE;

CREATE TABLE reports (
        id SERIAL PRIMARY KEY
);

DROP TABLE IF EXISTS levels;

CREATE TABLE levels (
        report_id INT,
        level INT,
        position INT,

        PRIMARY KEY (report_id, position),
        FOREIGN KEY (report_id) REFERENCES reports (id) ON DELETE CASCADE
);

CREATE OR REPLACE FUNCTION process_raw_data()
RETURNS VOID AS $$
DECLARE
        rec RECORD;
BEGIN
        FOR rec IN SELECT raw_data.raw_data FROM raw_data
        LOOP
                INSERT INTO reports DEFAULT VALUES;

                INSERT INTO levels (report_id, level, position)
                SELECT
                        (SELECT max(id) as report_id FROM reports) as report_id
                        , level
                        , ROW_NUMBER() OVER () AS position
                FROM (
                        SELECT
                                unnest(string_to_array(raw_data.raw_data, ' '))::INT AS level
                        FROM raw_data
                        WHERE raw_data.position = (SELECT max(id) as report_id FROM reports)
                ) raw_data_subquery;
        END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT process_raw_data();

WITH deltas AS (
        SELECT
                abs(l1.level - l2.level) AS delta_abs
                , CASE 
                        WHEN (l1.level - l2.level) = 0 THEN 0
                        ELSE (l1.level - l2.level) / abs(l1.level - l2.level)
                END AS direction
                , l1.position as l1_position
                , l2.position as l2_position
                , l1.report_id
        FROM levels l1
        INNER JOIN levels l2 ON l1.report_id = l2.report_id AND l2.position = l1.position + 1
)
, report_stats AS (
        SELECT
                report_id
                , SUM(direction) AS dir_total
                , COUNT(*) AS total
                , COUNT(*) FILTER (WHERE delta_abs > 3) AS excess_levels
        FROM deltas
        GROUP BY report_id
)
, part1 AS (
        SELECT
                1 AS part
                , COUNT(*) FILTER (
                        WHERE 1=1
                                AND abs(dir_total) = total
                                AND excess_levels = 0
                ) AS result
        FROM report_stats
)
, part2 AS (
        WITH invalid_deltas AS (
                SELECT
                        *
                        , min(l1_position) AS min_position
                FROM deltas
                WHERE 1=0
                        OR direction = 0
                        OR delta_abs > 3
                GROUP BY 1,2,3,4,5
                ORDER BY report_id
        )
        , fix1 AS (
              SELECT
                        d.report_id
                        , SUM(d.direction) FILTER (WHERE d.l1_position != id.min_position) AS dir_total
                        , COUNT(*) FILTER (WHERE d.l1_position != id.min_position) AS total
                        , COUNT(*) FILTER (WHERE d.delta_abs > 3 AND d.l1_position != id.min_position) AS excess_levels
                FROM deltas d
                INNER JOIN invalid_deltas id on d.report_id = id.report_id
                GROUP BY d.report_id
        )
        , fix2 AS (
                SELECT
                        d.report_id
                        , SUM(d.direction) FILTER (WHERE d.l2_position != id.min_position + 1) AS dir_total
                        , COUNT(*) FILTER (WHERE d.l2_position != id.min_position + 1) AS total
                        , COUNT(*) FILTER (WHERE d.delta_abs > 3 AND d.l2_position != id.min_position + 1) AS excess_levels
                FROM deltas d
                INNER JOIN invalid_deltas id on d.report_id = id.report_id
                GROUP BY d.report_id
        )
        , all_fixed AS (
                SELECT
                        1 AS fix_kind
                        , report_id
                        , (abs(dir_total) = total AND excess_levels = 0) AS valid
                FROM fix1
                UNION ALL
                SELECT
                        2 AS fix_kind
                        , report_id
                        , (abs(dir_total) = total AND excess_levels = 0) AS valid
                FROM fix2
        )
        SELECT
                2 AS part
                , (
                        SELECT
                                result
                        FROM part1
                ) + (
                        count(*) FILTER (
                                WHERE (fix_kind = 1 AND valid) OR (fix_kind = 2 AND valid)
                        )
                ) AS result
        FROM all_fixed
)

SELECT * FROM part1
UNION ALL
SELECT * FROM part2
ORDER BY part;
