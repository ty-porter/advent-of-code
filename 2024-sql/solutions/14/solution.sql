DROP TABLE IF EXISTS robots CASCADE;

CREATE TABLE robots (
        id SERIAL PRIMARY KEY
        , x INT NOT NULL
        , y INT NOT NULL
        , vx INT NOT NULL
        , vy INT NOT NULL
        , i INT NOT NULL DEFAULT 0
);

CREATE INDEX idx_robots_on_iteration ON robots (i);

INSERT INTO robots (x, y, vx, vy)
SELECT
        (regexp_match(rd.raw_data, 'p=(\d+)'))[1]::INT AS x
        , (regexp_match(rd.raw_data, 'p=\d+,(\d+)'))[1]::INT AS y
        , (regexp_match(rd.raw_data, 'v=(-?\d+)'))[1]::INT AS vx
        , (regexp_match(rd.raw_data, 'v=-?\d+,(-?\d+)'))[1]::INT AS vy
FROM raw_data rd;

-- % and mod() return negative numbers for negative dividend / positive divisor and vice versa.
CREATE OR REPLACE FUNCTION modulus(dividend INT, divisor INT)
RETURNS INT AS $$
DECLARE
        result INT;
BEGIN
        divisor := abs(divisor);
        result := mod(dividend, divisor);

        IF result < 0 THEN
                result := result + divisor;
        END IF;

        RETURN result;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION tick(until INT)
RETURNS VOID AS $$
DECLARE
        iteration INT;
BEGIN
        FOR iteration IN 1..until
        LOOP
                INSERT INTO robots (x, y, vx, vy, i)
                SELECT
                        modulus(r.x + r.vx, 101) AS x
                        , modulus(r.y + r.vy, 103) AS y
                        , r.vx AS vx
                        , r.vy AS vy
                        , r.i + 1 AS i
                FROM robots r
                WHERE r.i = iteration - 1;
        END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT tick(100);

WITH quadrants AS (
        SELECT
                count(*)   FILTER (WHERE x < floor(101 / 2) AND y < floor(103 / 2))  AS q1
                , count(*) FILTER (WHERE x > floor(101 / 2) AND y < floor(103 / 2))  AS q2
                , count(*) FILTER (WHERE x < floor(101 / 2) AND y > floor(103 / 2))  AS q3
                , count(*) FILTER (WHERE x > floor(101 / 2) AND y > floor(103 / 2))  AS q4
        FROM robots
        WHERE i = 100
)
SELECT
        q1 * q2 * q3 * q4 AS result
        , *
FROM quadrants;

DROP FUNCTION
        tick
        , modulus;

DROP TABLE IF EXISTS
        raw_data
        , robots;