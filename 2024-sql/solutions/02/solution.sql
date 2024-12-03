DROP TABLE IF EXISTS reports;

CREATE TABLE reports (
        id SERIAL PRIMARY KEY
        , position SERIAL
        , levels INT[]
        , valid BOOLEAN NOT NULL DEFAULT false
        , original BOOLEAN NOT NULL DEFAULT true
);

CREATE OR REPLACE FUNCTION is_valid(lvls INT[])
RETURNS BOOLEAN AS $$
DECLARE
        i INT;
        delta INT;
        magnitude INT;
BEGIN
        magnitude := 0;

        FOR i IN 1..(array_length(lvls, 1) - 1)
        LOOP
                delta := lvls[i] - lvls[i + 1];

                IF delta = 0 OR abs(delta) > 3 THEN
                        RETURN false;
                END IF;

                magnitude := magnitude + (delta / abs(delta));
        END LOOP;

        RETURN abs(magnitude) = array_length(lvls, 1) - 1;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION set_validity_trigger_fn()
RETURNS TRIGGER AS $$
BEGIN
        UPDATE reports
        SET valid = is_valid(levels)
        WHERE id = NEW.id;

        RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER set_validity_after_insert
AFTER INSERT ON reports
FOR EACH ROW
EXECUTE FUNCTION set_validity_trigger_fn();

CREATE OR REPLACE FUNCTION process_raw_data()
RETURNS VOID AS $$
BEGIN
        INSERT INTO reports (levels)
        SELECT
                ARRAY(
                        SELECT
                                element::INT
                        FROM unnest(string_to_array(raw_data.raw_data, ' ')) AS element
                ) AS lvls
        FROM raw_data;

END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION generate_permutations()
RETURNS VOID AS $$
DECLARE
        report RECORD;
        new_levels INT[];
        i INT;
BEGIN
        FOR report IN SELECT * FROM reports WHERE NOT valid
        LOOP
                FOR i in 1..array_length(report.levels, 1)
                LOOP
                        new_levels := ARRAY(
                                SELECT unnest(report.levels[1:i-1])
                                UNION ALL
                                SELECT unnest(report.levels[i+1:array_length(report.levels, 1)])
                        );

                        INSERT INTO reports (position, levels, original)
                        VALUES (report.position, new_levels, FALSE);
                END LOOP;
        END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT process_raw_data();
SELECT generate_permutations();

WITH part1 AS (
        SELECT
                1 AS part
                , COUNT(*) FILTER (WHERE valid AND original) AS result
        FROM reports
)
, part2 AS (
        SELECT
                2 AS part
                , COUNT(DISTINCT position) FILTER (WHERE valid) AS result
        FROM reports
)

SELECT
        update_solution(2, results.part, results.result)
FROM (
        SELECT * FROM part1
        UNION ALL
        SELECT * FROM part2
) AS results;

DROP TABLE IF EXISTS
        raw_data
        , reports;
DROP FUNCTION IF EXISTS
        process_raw_data
        , generate_permutations
        , set_validity_trigger_fn
        , is_valid;
DROP TRIGGER IF EXISTS
        set_validity_after_insert ON reports;
