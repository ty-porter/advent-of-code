set dayno=%1
set connection=postgresql://aoc:aoc@localhost:5432/aoc

psql -a -f .\common\setup.sql %connection%
psql -a -c "COPY raw_data (raw_data) FROM 'C:\\Users\tyler\development\advent-of-code\2024-sql\solutions\%dayno%\prompt.txt' WITH (FORMAT text)" %connection%
psql -a -f .\solutions\%dayno%\solution.sql %connection%