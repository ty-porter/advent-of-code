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

SELECT process_raw_data();
SELECT find_correct_pagesets();

WITH part1 AS (
        SELECT
                1 AS part
                , sum(pages[(array_length(pages, 1) /  2) + 1]) AS result
        FROM pagesets
        WHERE valid
)
-- This takes a VERY long time to run.
, part2 AS (
        WITH relevant_rules as (
                SELECT
                        p.id
                        , r.id AS rule_id
                        , array_position(p.pages, r.before_node) AS before_idx
                        , array_position(p.pages, r.after_node) AS after_idx
                        , r.before_node
                        , r.after_node
                        , r.rule_text
                FROM rules r
                INNER JOIN pagesets p 
                        ON r.before_node = ANY(p.pages) AND r.after_node = ANY(p.pages)
        )
        , pageset_validity AS (
                SELECT
                        id
                        , COUNT(*) != COUNT(*) FILTER(WHERE r.before_idx < r.after_idx) AS invalid
                FROM relevant_rules r
                GROUP BY id
        )
        , invalid_pagesets AS (
                SELECT
                        p.*
                FROM pagesets p
                INNER JOIN pageset_validity pv on p.id = pv.id
                WHERE pv.invalid
        )
        , sorted_pagesets AS (
                WITH RECURSIVE sp AS (
                        -- base case
                        SELECT
                                ip.id
                                , ip.pages
                                , 0 AS iter
                                , -1 AS before_node
                                , -1 AS after_node
                                , '' AS rule_text
                                , ARRAY[]::INT[] AS applied_rules
                        FROM invalid_pagesets ip

                        UNION ALL
                        
                        -- iteration
                        SELECT
                                sp.id
                                , ARRAY(
                                        SELECT
                                                CASE
                                                        WHEN i = array_position(sp.pages, r.before_node) THEN r.after_node
                                                        WHEN i = array_position(sp.pages, r.after_node) THEN r.before_node
                                                        ELSE v
                                                END
                                        FROM unnest(sp.pages) WITH ORDINALITY AS t(v, i)
                                ) AS pages
                                , sp.iter + 1 AS iter
                                , r.before_node
                                , r.after_node
                                , r.rule_text
                                , ARRAY(
                                        SELECT * FROM unnest(sp.applied_rules)
                                        UNION
                                        SELECT r.rule_id
                                ) AS applied_rules
                        FROM sp
                        INNER JOIN relevant_rules r
                                ON sp.id = r.id
                                AND r.before_node = ANY(sp.pages)
                                AND r.after_node = ANY(sp.pages)
                                AND array_position(sp.pages, r.before_node) > array_position(sp.pages, r.after_node)
                                AND array_position(sp.applied_rules, r.rule_id) IS NULL
                )
                SELECT * FROM sp
        )
        , pageset_max_iter AS (
                SELECT id, max(iter) AS max_iter FROM sorted_pagesets GROUP BY id
        )
        , ranked_sorted_pagesets AS (
                SELECT
                        s.*
                        , ROW_NUMBER() OVER (PARTITION BY s.id ORDER BY s.iter DESC) AS rank
                FROM sorted_pagesets s
                INNER JOIN pageset_max_iter p ON s.id = p.id AND s.id = p.id
                ORDER BY s.id ASC, s.iter DESC
        )

        SELECT
                2 AS part
                , sum(pages[(array_length(pages, 1) /  2) + 1]) AS result
        FROM ranked_sorted_pagesets WHERE rank = 1
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
        , find_correct_pagesets;
DROP INDEX IF EXISTS
        pages_gin_idx;
