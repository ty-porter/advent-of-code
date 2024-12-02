DROP TABLE IF EXISTS raw_data;

CREATE TABLE raw_data (
        position SERIAL PRIMARY KEY
        , raw_data VARCHAR
);

CREATE TABLE IF NOT EXISTS solutions (
        day INT
        , part INT
        , result VARCHAR

        , PRIMARY KEY (day, part)
);

CREATE OR REPLACE FUNCTION update_solution(newday INT, newpart INT, newresult ANYELEMENT)
RETURNS VOID AS $$
BEGIN
        INSERT INTO solutions (day, part, result)
        VALUES (newday, newpart, newresult::VARCHAR)
        ON CONFLICT (day, part)
        DO UPDATE
        SET result = EXCLUDED.result::VARCHAR;
END;
$$ LANGUAGE plpgsql;
