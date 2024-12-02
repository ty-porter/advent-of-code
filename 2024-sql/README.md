# Advent of Code 2024 (SQL)

This is an attempt to complete as much of AoC 2024 in SQL as possible.

## Requirements

1. A PostgreSQL server (completed using PG 16.6)
2. Some way to run commands against the server
  - `psql` is recommended, other GUI-based tools would probably work

## Usage

Each solution contains 3 files:

* `ingest.sql`
  - This defines a table that is used to house the raw data for the solution prior to further parsing.
  - Each row is 1 line of the prompt.
* `solution.sql`
  - This is the main SQL script that produces the solution.
* `prompt.txt`
  - The raw data that will be processed.

### Scripts

The solution directories are intentionally bare-bones to support multiple platforms and tools.

To run them, create an executable script that runs `ingest.sql`, performs a `COPY` from the correct path, and then runs `solution.sql`.

See [Sample Scripts](#sample-scripts) below for some examples on how this works.

### Sample Scripts

#### Windows

```powershell
set dayno=%1
set connection=postgresql://username:password@localhost:5432/postgres

psql --quiet -f .\%dayno%\ingest.sql %connection%
psql --quiet -c "COPY raw_data (raw_data) FROM 'C:\\Users\tyler\development\advent-of-code\2024-sql\%dayno%\prompt.txt' WITH (FORMAT text)" %connection%
psql --quiet -f .\%dayno%\solution.sql %connection%
```

Execution:

```
.\scripts\run.bat 01

 part |  result
------+----------
    1 |  2970687
    2 | 23963899
(2 rows)
```
