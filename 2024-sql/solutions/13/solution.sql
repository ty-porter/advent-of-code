DROP TABLE IF EXISTS machines CASCADE;

CREATE TABLE machines (
        id SERIAL PRIMARY KEY
        , machine_id INT NOT NULL
        , kind CHAR NOT NULL
        , x INT NOT NULL
        , y INT NOT NULL
        , cost INT NOT NULL DEFAULT 0
);

INSERT INTO machines (machine_id, kind, x, y, cost)
SELECT
        rd.position / 4 AS machine_id
        , 'A' AS kind
        , substr(rd.raw_data, 13, 2)::INT AS x
        , substr(rd.raw_data, 19, 2)::INT AS y
        , 3 AS cost
FROM raw_data rd
WHERE rd.position % 4 = 1;

INSERT INTO machines (machine_id, kind, x, y, cost)
SELECT
        rd.position / 4 AS machine_id
        , 'B' AS kind
        , substr(rd.raw_data, 13, 2)::INT AS x
        , substr(rd.raw_data, 19, 2)::INT AS y
        , 1 AS cost
FROM raw_data rd
WHERE rd.position % 4 = 2;

INSERT INTO machines (machine_id, kind, x, y)
SELECT
        rd.position / 4 AS machine_id
        , 'P' AS kind
        , (regexp_match(rd.raw_data, 'X=(\d+)'))[1]::INT as x
        , (regexp_match(rd.raw_data, 'Y=(\d+)'))[1]::INT as y
FROM raw_data rd
WHERE rd.position % 4 = 3;

CREATE OR REPLACE VIEW equations AS (
        SELECT
                p.machine_id AS id
                , a.x::NUMERIC * b.y::NUMERIC - a.y::NUMERIC * b.x::NUMERIC AS determinant
                , b.x::NUMERIC * p.y::NUMERIC - b.y::NUMERIC * p.x::NUMERIC AS a
                , a.x::NUMERIC * p.y::NUMERIC - a.y::NUMERIC * p.x::NUMERIC AS b
        FROM machines p
        INNER JOIN machines a ON a.machine_id = p.machine_id AND a.kind = 'A'
        INNER JOIN machines b ON b.machine_id = p.machine_id AND b.kind = 'B'
        WHERE p.kind = 'P'
);


CREATE OR REPLACE VIEW scaled_equations AS (
        SELECT
                p.machine_id AS id
                , a.x::NUMERIC * b.y::NUMERIC - a.y::NUMERIC * b.x::NUMERIC AS determinant
                , b.x::NUMERIC * (p.y::NUMERIC + 1e13) - b.y::NUMERIC * (p.x::NUMERIC + 1e13) AS a
                , a.x::NUMERIC * (p.y::NUMERIC + 1e13) - a.y::NUMERIC * (p.x::NUMERIC + 1e13) AS b
        FROM machines p
        INNER JOIN machines a ON a.machine_id = p.machine_id AND a.kind = 'A'
        INNER JOIN machines b ON b.machine_id = p.machine_id AND b.kind = 'B'
        WHERE p.kind = 'P'
);

WITH part1 AS (
        WITH costs AS (
                SELECT
                        abs(a / determinant * 3) + abs(b / determinant) AS cost
                FROM equations
                WHERE determinant != 0
                        AND floor(a / determinant) = a / determinant
                        AND floor(b / determinant) = b / determinant
        )
        SELECT
                1 AS part
                , sum(cost::BIGINT) AS result
        FROM costs
),
part2 AS (
        WITH costs AS (
                SELECT
                        abs(a / determinant * 3) + abs(b / determinant) AS cost
                FROM scaled_equations
                WHERE determinant != 0
                        AND floor(a / determinant) = a / determinant
                        AND floor(b / determinant) = b / determinant
        )
        SELECT
                2 AS part
                , sum(cost::BIGINT) AS result
        FROM costs
)

SELECT
        update_solution(13, results.part, results.result)
FROM (
        SELECT * FROM part1
        UNION ALL
        SELECT * FROM part2
) AS results;


DROP TABLE IF EXISTS
        raw_data
        , machines
CASCADE;