package main

import (
	"fmt"
	"math"
	"strconv"
	"strings"

	"github.com/ty-porter/advent-of-code/2023/util"
)

func main() {
	lines, err := util.LoadInput()
	util.CheckErr(err)

	fmt.Println("Part 1: " + part1(lines))
	fmt.Println("Part 2: " + part2(lines))
}

func part1(lines []string) string {
	times := strings.Fields(lines[0])
	records := strings.Fields(lines[1])

	margin := 1

	for i, time := range times {
		if i == 0 {
			continue
		}

		time, _ := strconv.Atoi(time)
		record, _ := strconv.Atoi(records[i])

		margin *= calculateMargin(time, record)
	}

	return strconv.Itoa(margin)
}

func part2(lines []string) string {
	times := strings.Fields(lines[0])
	records := strings.Fields(lines[1])

	timeStr := ""
	recordStr := ""

	for i, time := range times {
		if i == 0 {
			continue
		}

		timeStr += time
		recordStr += records[i]
	}

	time, _ := strconv.Atoi(timeStr)
	record, _ := strconv.Atoi(recordStr)

	return strconv.Itoa(calculateMargin(time, record))
}

func calculateMargin(d int, r int) int {
	/*
	  Record distance traveled (R) is given by:

	    R < (D - T) * T

	  where D = race duration and T = time held.

	  This forms a quadratic equation:

	    0 < -T^2 + DT - R

	      or, in terms of x:

	    0 < -x^2 + Dx - R

	  Roots of this equation are:

	    -D +/- sqrt( D^2 - 4R )
	    --------------------------
	                -2

	  Margin will be:
	    Range of [ ⌈ minimum root ⌉, ⌊ maximum root ⌋ ]
	*/
	D := float64(d)
	R := float64(r)

	r1 := (-D + math.Sqrt(D*D-4*R)) / -2
	r2 := (-D - math.Sqrt(D*D-4*R)) / -2

	// Handle exclusive less than in case roots are whole numbers
	if math.Remainder(r1, 1.0) == 0 {
		r1 += 1.0
	}
	if math.Remainder(r2, 1.0) == 0 {
		r2 -= 1.0
	}

	return int(math.Floor(r2)-math.Ceil(r1)) + 1
}
