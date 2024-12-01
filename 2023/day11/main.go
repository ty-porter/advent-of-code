package main

import (
  "github.com/ty-porter/advent-of-code-2023/util"
  "fmt"
  "strconv"
)

type Point struct {
  x, y int
}

const GALAXY = '#'

func main() {
  lines, err := util.LoadInput("day11");
  util.CheckErr(err)

  fmt.Println("Part 1: " + part1(lines))
  fmt.Println("Part 2: " + part2(lines))
}

func part1(lines []string) string {
  result := performCalculation(lines, 1)

  return strconv.Itoa(result)
}
func part2(lines []string) string {
  result := performCalculation(lines, 1000000 - 1)

  return strconv.Itoa(result)
}

func performCalculation(lines []string, amt int) int {
  galaxies := make([]*Point, 0)

  xExpansion := make([]int, len(lines[0]))
  yExpansion := make([]int, len(lines))

  for i := 0; i < max(len(xExpansion), len(yExpansion)); i++ {
    if i < len(xExpansion) { xExpansion[i] = 1 }
    if i < len(yExpansion) { yExpansion[i] = 1 }
  }

  for y, row := range(lines) {
    for x, col := range(row) {
      if col == GALAXY {
        galaxy := Point { x: x, y: y }
        galaxies = append(galaxies, &galaxy)
        
        yExpansion[y] = 0
        xExpansion[x] = 0
      }
    }
  }

  sum := 0
  for i, g1 := range(galaxies) {
    for j, g2 := range(galaxies) {
      if i == j { continue }

      sum += distance(g1, g2, xExpansion, yExpansion, amt)
    }
  }

  return sum / 2
}

func distance(a *Point, b *Point, xExpansion []int, yExpansion []int, expansionAmt int) int {
  minX := min(a.x, b.x)
  maxX := max(a.x, b.x)
  minY := min(a.y, b.y)
  maxY := max(a.y, b.y)

  dx := maxX - minX
  dy := maxY - minY

  if dx > 0 {
    for _, expansion := range(xExpansion[minX:maxX]) {
      dx += expansion * expansionAmt
    }
  }

  if dy > 0 {
    for _, expansion := range(yExpansion[minY:maxY]) {
      dy += expansion * expansionAmt
    }
  }

  return dx + dy
}
