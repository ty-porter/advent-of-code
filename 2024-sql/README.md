# Advent of Code 2024 (SQL)

This is an attempt to complete as much of AoC 2024 in SQL as possible.

## Requirements

1. A PostgreSQL server (completed using PG 16.6)
2. Some way to run commands against the server
    - `psql` is recommended, other GUI-based tools would probably work

## Usage

Each solution contains 2 files:

* `solution.sql`
  - This is the main SQL script that produces the solution.
* `prompt.txt`
  - The raw data that will be processed.

### Scripts

The solution directories are intentionally bare-bones to support multiple platforms and tools.

To run them, create an executable script that runs `common/setup.sql`, performs a `COPY` from the correct path, and then runs `solution.sql`.

See [Sample Scripts](#sample-scripts) below for some examples on how this works.

### Tables

There are two main tables that are built for each solution called `raw_data` and `solutions`. `raw_data` is torn down per solution script, but the `solutions` table is retained and stores solutions long-term.

```sql
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
```

The `raw_data` table stores each line of the puzzle input as a separate row -- any further post-processing will need to occur in a solution script.

The `solutions` table stores solutions to each puzzle. You can query the solutions via:

```sql
SELECT * FROM solutions ORDER BY day ASC, part ASC;
```

You can update the solutions table with a function `update_solution(newday INT, newpart INT, newresult ANYELEMENT)` which will overwrite the solution for a given `(day, part)` and accepts any datatype that can be cast to a `VARCHAR`.

### Sample Scripts

#### Windows

```powershell
# scripts/run.bat
@echo off

set dayno=%1
set connection=postgresql://aoc:aoc@localhost:5432/aoc

psql -c "SET client_min_messages TO NOTICE;" %connection%
psql --quiet -f .\common\setup.sql %connection%
psql --quiet -c "COPY raw_data (raw_data) FROM 'C:\\Users\tyler\development\advent-of-code\2024-sql\solutions\%dayno%\prompt.txt' WITH (FORMAT text)" %connection%
psql --quiet -f .\solutions\%dayno%\solution.sql %connection%
```

Execution:

```
.\scripts\run.bat 01

 part |  result
------+----------
    1 |  1234567
    2 | 12345678
(2 rows)
```
