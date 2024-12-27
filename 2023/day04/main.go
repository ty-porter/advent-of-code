package main

import (
	"fmt"
	"math"
	"strconv"
	"strings"

	"github.com/ty-porter/advent-of-code/2023/util"
)

type Card struct {
	count int
	value int
}

func main() {
	lines, err := util.LoadInput("day4")
	util.CheckErr(err)

	fmt.Println("Part 1: " + part1(lines))
	fmt.Println("Part 2: " + part2(lines))
}

func part1(lines []string) string {
	sum := 0

	for _, line := range lines {
		parts := strings.Split(strings.Split(line, ": ")[1], " | ")
		winners, card := strings.Fields(parts[0]), strings.Fields(parts[1])
		winningValues := make(map[string]bool)

		for _, winner := range winners {
			winningValues[winner] = true
		}

		matches := findMatches(winningValues, card)
		sum += int(math.Pow(2, float64(matches-1)))
	}

	return strconv.Itoa(sum)
}

func part2(lines []string) string {
	cards := make(map[int]*Card)

	for i, _ := range lines {
		cards[i] = &Card{count: 1, value: 0}
	}

	for i, line := range lines {
		parts := strings.Split(strings.Split(line, ": ")[1], " | ")
		winners, card := strings.Fields(parts[0]), strings.Fields(parts[1])
		winningValues := make(map[string]bool)

		for _, winner := range winners {
			winningValues[winner] = true
		}

		matches := findMatches(winningValues, card)
		cards[i].value = int(math.Pow(2, float64(matches-1)))

		for j := 1; j <= matches; j++ {
			cards[i+j].count += cards[i].count
		}
	}

	sum := 0
	for _, card := range cards {
		sum += card.count
	}

	return strconv.Itoa(sum)
}

func findMatches(winningValues map[string]bool, card []string) (matches int) {
	for _, pick := range card {
		if winningValues[pick] {
			matches += 1
		}
	}

	return matches
}
