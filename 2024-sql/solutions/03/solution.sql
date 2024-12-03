DROP TABLE IF EXISTS reports;

CREATE TABLE memory (
        id SERIAL PRIMARY KEY
        , operation BOOLEAN NOT NULL DEFAULT false
        , op1 INT
        , op2 INT
        , mod_amt INT NOT NULL DEFAULT 0
        , raw_data VARCHAR
);

CREATE OR REPLACE FUNCTION set_mod_amt_trigger_fn()
RETURNS TRIGGER AS $$
BEGIN
        UPDATE memory
        SET mod_amt = (
                SELECT
                        CASE m.raw_data WHEN 'do()' THEN 1 ELSE 0 END AS amt
                FROM memory m
                WHERE m.operation = false AND m.id < NEW.id
                ORDER BY m.id DESC
                LIMIT 1
        )
        WHERE id = NEW.id;

        RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER set_mod_amt_after_insert
AFTER INSERT ON MEMORY
FOR EACH ROW
WHEN (NEW.operation = true)
EXECUTE FUNCTION set_mod_amt_trigger_fn();

CREATE OR REPLACE FUNCTION process_raw_data()
RETURNS VOID AS $$
BEGIN
        WITH inst AS (
                -- Need to seed the first instruction as do()
                SELECT ARRAY['do()'] AS raw_data
                UNION ALL
                SELECT
                        regexp_matches(
                                raw_data.raw_data,
                                '(mul\((\d+),(\d+)\)|do\(\)|don''t\(\))',
                                'g'
                        ) AS raw_data
                FROM raw_data
        )
        INSERT INTO memory (operation, op1, op2, raw_data)
        SELECT
                raw_data[1] like 'mul%' AS operation
                , CASE WHEN raw_data[2] IS NOT NULL THEN raw_data[2]::INT ELSE NULL END as op1
                , CASE WHEN raw_data[3] IS NOT NULL THEN raw_data[3]::INT ELSE NULL END as op2
                , raw_data[1]
        FROM inst;
END;
$$ LANGUAGE plpgsql;

SELECT process_raw_data();

WITH part1 AS (
        SELECT
                1 AS part
                , SUM(op1 * op2) AS result
        FROM memory
        WHERE operation = true
)
, part2 AS (
        SELECT
                2 AS part
                , SUM(op1 * op2 * mod_amt) AS result
        FROM memory
        WHERE operation = true
)

SELECT
        update_solution(3, results.part, results.result)
FROM (
        SELECT * FROM part1
        UNION ALL
        SELECT * FROM part2
) AS results;

DROP TABLE IF EXISTS
        raw_data
        , memory;
DROP FUNCTION IF EXISTS
        process_raw_data
        , set_mod_amt_trigger_fn;
DROP TRIGGER IF EXISTS
        set_mod_amt_after_insert ON memory;
