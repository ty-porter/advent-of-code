DROP TABLE IF EXISTS rules, pagesets;

CREATE TABLE rules (
        id SERIAL PRIMARY KEY
        , before_node INT NOT NULL
        , after_node INT NOT NULL
        , rule_text TEXT NOT NULL
);

CREATE TABLE pagesets (
        id SERIAL PRIMARY KEY
        , pages INT[] NOT NULL
        , valid BOOLEAN NOT NULL DEFAULT false
);

CREATE INDEX pages_gin_idx ON pagesets USING GIN (pages);

CREATE OR REPLACE FUNCTION process_raw_data()
RETURNS VOID AS $$
BEGIN
        INSERT INTO rules (before_node, after_node, rule_text)
        SELECT
                (string_to_array(r.raw_data, '|'))[1]::INT AS before_node
                , (string_to_array(r.raw_data, '|'))[2]::INT AS after_node
                , r.raw_data AS rule_text
        FROM raw_data r
        WHERE r.raw_data LIKE '%|%';

        INSERT INTO pagesets (pages)
        SELECT
                ARRAY(SELECT element::INT FROM unnest(string_to_array(r.raw_data, ',')) AS element) AS pages
        FROM raw_data r
        WHERE r.raw_data LIKE '%,%';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION find_correct_pagesets()
RETURNS VOID AS $$
BEGIN
        WITH relevant_rules as (
                SELECT
                        p.id
                        , array_position(p.pages, r.before_node) AS before_idx
                        , array_position(p.pages, r.after_node) AS after_idx
                FROM rules r
                INNER JOIN pagesets p 
                        ON r.before_node = ANY(p.pages) AND r.after_node = ANY(p.pages)

        )
        , pageset_validity AS (
                SELECT
                        id
                        , COUNT(*) = COUNT(*) FILTER(WHERE before_idx < after_idx) AS valid
                FROM relevant_rules 
                GROUP BY id
        )
        UPDATE pagesets p
        SET valid = true
        FROM pageset_validity pv
        WHERE pv.id = p.id AND pv.valid;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION generate_correct_pageset(pages INT[])
RETURNS INT[] AS $$
DECLARE
        p1 INT;
        p2 INT;
        i INT;
        j INT;
BEGIN
        FOR i IN 1..array_length(pages, 1) LOOP
                FOR j IN i+1..array_length(pages, 1) LOOP
                        p1 := pages[i];
                        p2 := pages[j];

                        IF EXISTS (SELECT 1 FROM rules WHERE before_node = p2 AND after_node = p1) THEN
                                pages[i] := p2;
                                pages[j] := p1;

                                RETURN generate_correct_pageset(pages);
                        END IF;
                END LOOP;
        END LOOP;

        return pages;
END;
$$ LANGUAGE plpgsql;

SELECT process_raw_data();
SELECT find_correct_pagesets();

WITH part1 AS (
        SELECT
                1 AS part
                , sum(pages[(array_length(pages, 1) /  2) + 1]) AS result
        FROM pagesets
        WHERE valid
)
, part2 AS (
        WITH corrected_pagesets AS (
                SELECT
                        generate_correct_pageset(pages) AS pages
                FROM pagesets
                WHERE NOT valid
        )
        SELECT
                2 AS part
                , sum(pages[(array_length(pages, 1) /  2) + 1]) AS result
        FROM corrected_pagesets
)

SELECT
        update_solution(5, results.part, results.result)
FROM (
        SELECT * FROM part1
        UNION ALL
        SELECT * FROM part2
) AS results;

DROP TABLE IF EXISTS
        raw_data
        , rules
        , pagesets;
DROP FUNCTION IF EXISTS
        process_raw_data
        , find_correct_pagesets
        , generate_correct_pageset;
DROP INDEX IF EXISTS
        pages_gin_idx;
