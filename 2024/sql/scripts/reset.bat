set connection=postgresql://aoc:aoc@localhost:5432/aoc

psql --quiet -c "DROP TABLE IF EXISTS solutions;" %connection%