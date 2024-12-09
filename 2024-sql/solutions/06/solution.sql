DROP TABLE IF EXISTS grid;

CREATE TABLE grid (
        id SERIAL PRIMARY KEY
        , x INT NOT NULL
        , y INT NOT NULL
        , c VARCHAR NOT NULL
);

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

CREATE OR REPLACE FUNCTION traverse()
RETURNS TABLE (step INT, x INT, y INT, dir INT[]) AS $$
DECLARE
        cur_x INT;
        cur_y INT;
        cur_dir INT[] := ARRAY[0, -1];
        step_count INT := 0;
BEGIN
        SELECT grid.x, grid.y INTO cur_x, cur_y
        FROM grid
        WHERE grid.c = '^'
        LIMIT 1;

        LOOP
                IF NOT EXISTS (
                        SELECT 1 FROM grid WHERE grid.x = cur_x AND grid.y = cur_y
                ) THEN
                        EXIT;
                END IF;

                step := step_count;
                x := cur_x;
                y := cur_y;
                dir := cur_dir;

                RETURN NEXT;

                IF EXISTS (
                        SELECT 1 FROM grid WHERE grid.x = cur_x + cur_dir[1] AND grid.y = cur_y + cur_dir[2] AND grid.c = '#'
                ) THEN
                        CASE cur_dir
                                WHEN ARRAY[ 0, -1] THEN cur_dir := ARRAY[ 1,  0];
                                WHEN ARRAY[ 1,  0] THEN cur_dir := ARRAY[ 0,  1];
                                WHEN ARRAY[ 0,  1] THEN cur_dir := ARRAY[-1,  0];
                                WHEN ARRAY[-1,  0] THEN cur_dir := ARRAY[ 0, -1];
                        END CASE;
                END IF;

                cur_x := cur_x + cur_dir[1];
                cur_y := cur_y + cur_dir[2];

                step_count := step_count + 1;

                IF step_count > 10000 THEN
                        RAISE EXCEPTION 'Traversal exceeded maximum steps (1000).';
                END IF;
        END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT
        update_solution(6, 1, COUNT(DISTINCT (x, y)))
        , update_solution(6, 2, '<SKIPPED>'::TEXT)
FROM traverse();

DROP FUNCTION IF EXISTS
        process_raw_data
        , traverse;
