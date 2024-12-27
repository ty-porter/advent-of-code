package main

import (
	"fmt"
	"strconv"

	"github.com/ty-porter/advent-of-code/2023/util"
)

type Coord struct {
	x int
	y int
}

func main() {
	lines, err := util.LoadInput("day3")
	util.CheckErr(err)

	fmt.Println("Part 1: " + part1(lines))
	fmt.Println("Part 2: " + part2(lines))
}

func part1(lines []string) string {
	sum := 0

	for i, line := range lines {
		buffer := make([]rune, 0)
		valid := false

		for j, c := range line {
			if isNumber(c) {
				buffer = append(buffer, c)
				if isAdjacentToAnyTarget(j, i, lines) {
					valid = true
				}
			}

			if !isNumber(c) || j == len(line)-1 {
				value, _ := strconv.Atoi(string(buffer))

				if valid {
					sum += value
				}

				buffer = make([]rune, 0)
				valid = false
			}
		}
	}

	return strconv.Itoa(sum)
}

func part2(lines []string) string {
	gears := make(map[Coord][]int)
	sum := 0

	for i, line := range lines {
		buffer := make([]rune, 0)
		gearCoord := Coord{x: -1, y: -1}

		for j, c := range line {
			if isNumber(c) {
				buffer = append(buffer, c)

				if gearCoord.x < 0 || gearCoord.y < 0 {
					gearCoord = adjacentGear(j, i, lines, '*')
				}
			}

			if !isNumber(c) || j == len(line)-1 {
				value, _ := strconv.Atoi(string(buffer))

				if gearCoord.x >= 0 && gearCoord.y >= 0 {
					gears[gearCoord] = append(gears[gearCoord], value)
				}

				buffer = make([]rune, 0)
				gearCoord = Coord{x: -1, y: -1}
			}
		}
	}

	for _, values := range gears {
		if len(values) != 2 {
			continue
		}

		sum += values[0] * values[1]
	}

	return strconv.Itoa(sum)
}

func isAnySymbol(r rune) bool {
	if isNumber(r) {
		return false
	}
	if r == '.' {
		return false
	}

	return true
}

func isNumber(r rune) bool {
	return r-'0' >= 0 && r-'0' <= 9
}

func isAdjacentToAnyTarget(x int, y int, lines []string) bool {
	offsets := [][]int{{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}}

	for _, offset := range offsets {
		dx := x + offset[0]
		dy := y + offset[1]

		// Index OOB
		if dx < 0 || dx >= len(lines[0]) || dy < 0 || dy >= len(lines) {
			continue
		}

		c := rune(lines[dy][dx])

		if isAnySymbol(c) {
			return true
		}
	}

	return false
}

func adjacentGear(x int, y int, lines []string, target rune) Coord {
	offsets := [][]int{{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}}

	for _, offset := range offsets {
		dx := x + offset[0]
		dy := y + offset[1]

		// Index OOB
		if dx < 0 || dx >= len(lines[0]) || dy < 0 || dy >= len(lines) {
			continue
		}

		c := rune(lines[dy][dx])

		if c == target {
			return Coord{x: dx, y: dy}
		}
	}

	return Coord{x: -1, y: -1}
}
