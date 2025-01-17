# advent-of-code/2023

Solutions for Advent of Code 2023

# Usage

Navigate to a solution directory: `advent-of-code/2023/day01`

## Run full solution for a day

```sh
go run main.go

# Runs with a full input at day01/input.txt
```

## Run development solution with a custom input file

```sh
go run main.go test

# Runs with a test input at day01/test.txt
```

## Force run a skipped solution (if applicable)

```sh
go run main.go -run-part2
go run main.go -run-part2 test

# Some days can skip parts if the algorithm is inefficient.
```

# Development

## Scaffold a new solution

```sh
./generate.sh
```

This will create a new directory `/day<NUMBER>`, add a `main.go` template, initialize a Go package, and add blank input files.
