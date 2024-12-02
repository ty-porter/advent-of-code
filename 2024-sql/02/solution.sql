DROP TABLE IF EXISTS reports;

CREATE TABLE reports (
        id SERIAL PRIMARY KEY
        , position SERIAL
        , levels INT[]
        , valid BOOLEAN NOT NULL DEFAULT false
        , original BOOLEAN NOT NULL DEFAULT true
);

CREATE OR REPLACE FUNCTION is_in_bound(lvls INT[])
RETURNS BOOLEAN AS $$
DECLARE
        i INT;
        delta INT;
BEGIN
        FOR i IN 1..(array_length(lvls, 1) - 1)
        LOOP
                delta := lvls[i] - lvls[i + 1];

                IF delta = 0 OR abs(delta) > 3 THEN
                        RETURN false;
                END IF;
        END LOOP;

        RETURN true;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION is_strictly_decreasing(lvls INT[])
RETURNS BOOLEAN AS $$
DECLARE
        i INT;
BEGIN
        FOR i IN 1..(array_length(lvls, 1) - 1)
        LOOP
                IF lvls[i] - lvls[i + 1] >= 0 THEN
                        RETURN false;
                END IF;
        END LOOP;

        RETURN true;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION is_strictly_increasing(lvls INT[])
RETURNS BOOLEAN AS $$
DECLARE
        i INT;
BEGIN
        FOR i IN 1..(array_length(lvls, 1) - 1)
        LOOP
                IF lvls[i] - lvls[i + 1] <= 0 THEN
                        RETURN false;
                END IF;
        END LOOP;

        RETURN true;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION check_validity_trigger_fn()
RETURNS TRIGGER AS $$
BEGIN
        UPDATE reports
        SET valid = (
                is_in_bound(levels)
                AND
                (
                        is_strictly_decreasing(levels)
                        OR
                        is_strictly_increasing(levels)
                )
        )
        WHERE id = NEW.id;

        RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER check_validity_after_insert
AFTER INSERT ON reports
FOR EACH ROW
EXECUTE FUNCTION check_validity_trigger_fn();

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

SELECT * FROM part1
UNION ALL
SELECT * FROM part2;

DROP TABLE IF EXISTS
        raw_data
        , reports;
DROP FUNCTION IF EXISTS
        process_raw_data
        , generate_permutations
        , check_validity_trigger_fn
        , is_in_bound, is_strictly_decreasing
        , is_strictly_increasing;
DROP TRIGGER IF EXISTS
        check_validity_after_insert ON reports;