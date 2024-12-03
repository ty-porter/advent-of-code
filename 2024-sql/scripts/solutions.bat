@echo off

set connection=postgresql://aoc:aoc@localhost:5432/aoc

psql --quiet -c "SELECT * FROM solutions ORDER BY day ASC, part ASC;" %connection%