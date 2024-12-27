package main

import (
	"fmt"
	"strings"

	"github.com/ty-porter/advent-of-code/2023/util"
)

func main() {
	lines, err := util.LoadInput()
	util.CheckErr(err)

	parsedLines := make([][]int, 0)

	for _, line := range lines {
		fields := strings.Fields(line)
		values := make([]int, len(fields))

		for i, field := range fields {
			values[i] = util.ForceInt(field)
		}

		parsedLines = append(parsedLines, values)
	}

	fmt.Printf("Part 1: %d\n", part1(parsedLines))
	fmt.Printf("Part 2: %d\n", part2(parsedLines))
}

func part1(lines [][]int) int {
	sum := 0

	for _, values := range lines {
		sum += values[len(values)-1] + predict(values)
	}

	return sum
}

func part2(lines [][]int) int {
	difference := 0

	for _, values := range lines {
		difference += values[0] - reversePredict(values)
	}

	return difference
}

func predict(values []int) int {
	sum := 0
	pLen := len(values) - 1
	p := make([]int, pLen)

	for i, v := range values {
		sum += v

		if i < pLen {
			p[i] = values[i+1] - values[i]
		}
	}

	if sum == 0 {
		return 0
	}

	return p[pLen-1] + predict(p)
}

func reversePredict(values []int) int {
	sum := 0
	pLen := len(values) - 1
	p := make([]int, pLen)

	for i := pLen - 1; i >= 0; i-- {
		v := values[i]
		sum += v

		p[i] = values[i+1] - v
	}

	if sum == 0 {
		return 0
	}

	return p[0] - reversePredict(p)
}
