package main

import (
	"fmt"
	"math"
	"slices"
	"strconv"
	"strings"

	"github.com/ty-porter/advent-of-code/2023/util"
)

type hand struct {
	labels string
	bid    int
	rank   int
}

type rankFn func(string) int
type labelValueFn func(byte) int

func main() {
	lines, err := util.LoadInput()
	util.CheckErr(err)

	fmt.Println("Part 1: " + part1(lines))
	fmt.Println("Part 2: " + part2(lines))
}

func part1(lines []string) string {
	hands := parseLines(lines)

	slices.SortFunc(hands, func(a, b hand) int { return compareHands(a, b, calculateLabelValue) })

	total := calculateTotal(hands)

	return strconv.Itoa(total)
}

func part2(lines []string) string {
	hands := parseLines(lines)

	slices.SortFunc(hands, func(a, b hand) int { return compareHands(a, b, calculateLabelValueWithWilds) })

	total := calculateTotal(hands)

	return strconv.Itoa(total)
}

func parseLines(lines []string) []hand {
	hands := make([]hand, 0)

	for _, line := range lines {
		hand := parseLine(line, calculateRankWithWilds)

		hands = append(hands, hand)
	}

	return hands
}

func parseLine(line string, calculateRank rankFn) hand {
	fields := strings.Fields(line)

	hand := new(hand)
	hand.labels = fields[0]
	hand.rank = calculateRank(fields[0])
	hand.bid = util.ForceInt(fields[1])

	return *hand
}

func calculateTotal(hands []hand) int {
	total := 0

	for i, hand := range hands {
		total += hand.bid * (i + 1)
	}

	return total
}

func powInt(x, y int) int {
	return int(math.Pow(float64(x), float64(y)))
}

func compareHands(a, b hand, calculateLabelValue labelValueFn) int {
	if a.rank < b.rank {
		return -1
	}
	if a.rank > b.rank {
		return 1
	}

	for i := 0; i < len(a.labels); i++ {
		va := calculateLabelValue(a.labels[i])
		vb := calculateLabelValue(b.labels[i])

		if va < vb {
			return -1
		}
		if va > vb {
			return 1
		}
	}

	return 0
}

func calculateRank(line string) int {
	seen := make(map[rune]int)
	counts := make([]int, len(line)+1)
	i := 1

	for _, c := range line {
		if seen[c] == 0 {
			seen[c] = i
			i += 1
		}

		counts[seen[c]] += 1
	}

	slices.Sort(counts)

	rank := 0
	for i := 0; i < len(counts)-1; i++ {
		v := counts[i+1]
		rank += v * powInt(10, i)
	}

	return rank
}

func calculateLabelValue(l byte) int {
	v := int(rune(l) - '0')

	if 2 <= v && v <= 9 {
		return v
	}

	switch l {
	case 'A':
		return 14
	case 'K':
		return 13
	case 'Q':
		return 12
	case 'J':
		return 11
	case 'T':
		return 10
	}

	panic(fmt.Sprintf("Invalid card: %s", strconv.QuoteRune(rune(l))))
}

func calculateRankWithWilds(line string) int {
	rank := calculateRank(line)
	j := 0

	for _, c := range line {
		if c == 'J' {
			j++
		}
	}

	switch j {
	case 0:
		break
	case 1:
		switch rank {
		case 11111:
			rank = 21110
		case 21110:
			rank = 31100
		case 22100:
			rank = 32000
		case 31100:
			rank = 41000
		case 41000:
			rank = 50000
		}
	case 2:
		switch rank {
		case 21110:
			rank = 31100
		case 22100:
			rank = 41000
		case 32000:
			rank = 50000
		}
	case 3:
		switch rank {
		case 31100:
			rank = 41000
		case 32000:
			rank = 50000
		}
	case 4, 5:
		rank = 50000
	}

	return rank
}

func calculateLabelValueWithWilds(l byte) int {
	if l == 'J' {
		return 1
	}

	return calculateLabelValue(l)
}
