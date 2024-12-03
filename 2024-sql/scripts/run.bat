@echo off

set dayno=%1
set connection=postgresql://aoc:aoc@localhost:5432/aoc

psql -c "SET client_min_messages TO NOTICE;" %connection%
psql --quiet -f .\common\setup.sql %connection%
psql --quiet -c "COPY raw_data (raw_data) FROM 'C:\\Users\tyler\development\advent-of-code\2024-sql\solutions\%dayno%\prompt.txt' WITH (FORMAT text)" %connection%
psql --quiet -f .\solutions\%dayno%\solution.sql %connection%