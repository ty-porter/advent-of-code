package main

import (
  "github.com/ty-porter/advent-of-code-2023/util"
  "fmt"
  "strings"
  "strconv"
)

type SeedMap struct {
  src int
  dst int
  rng int
}

func main() {
  lines, err := util.LoadInput("day5");
  util.CheckErr(err)

  fmt.Println("Part 1: " + part1(lines))

  // This is not pretty. Each seed range encompasses hundreds of millions of seeds.
  // Runs on the order of minutes, so running Part 2 today is behind a CLI flag.
  flags := util.GetFlags()

  if flags.HasFlag("runPart2") {
    fmt.Println("Part 2: " + part2(lines))
  } else {
    fmt.Println("Part 2: << Not run due to inefficient brute force algorithm. Use flag `run-part2` to run. >>")
  }

}

func part1(lines []string) string {
  seeds := parseSeeds(lines)
  seedMapGroups := parseSeedMapGroups(lines[2:len(lines)])

  minLocation := 1 << 63 - 1

  for _, value := range seeds {
    for _, seedMapGroup := range seedMapGroups {
      for _, seedMap := range seedMapGroup {
        if seedMap.src <= value && value <= seedMap.src + seedMap.rng - 1 {
          value = seedMap.dst + value - seedMap.src

          break
        }
      }
    }

    if value < minLocation { minLocation = value }
  }

  return strconv.Itoa(minLocation)
}

func part2(lines []string) string {
  seeds := parseSeeds(lines)
  seedMapGroups := parseSeedMapGroups(lines[2:len(lines)])

  minLocation := 1 << 63 - 1

  for i, rng := range seeds {
    if i % 2 != 1 { continue }

    for seed := seeds[i - 1]; seed < seeds[i - 1] + rng; seed++ {
      value := seed

      for _, seedMapGroup := range seedMapGroups {
        for _, seedMap := range seedMapGroup {
          if seedMap.src <= value && value <= seedMap.src + seedMap.rng - 1 {
            value = seedMap.dst + value - seedMap.src

            break
          }
        }
      }

      if value < minLocation { minLocation = value }
    }
  }

  return strconv.Itoa(minLocation)
}

func parseSeeds(lines []string) []int {
  seeds := make([]int, 0)

  for i, value := range strings.Fields(lines[0]) {
    if i == 0 { continue }

    seed, _ := strconv.Atoi(value)
    seeds = append(seeds, seed)
  }

  return seeds
}

func parseSeedMapGroups(lines []string) [][]*SeedMap {
  seedMapGroups := make([][]*SeedMap, 0)

  start := 0

  for stop, line := range lines {
    if (start != stop && len(line) == 0) || stop == len(lines) - 1 {
      seedMapGroups = append(seedMapGroups, parseSeedMaps(lines[start:stop]))
      start = stop + 1
    }
  }

  return seedMapGroups
}

func parseSeedMaps(lines []string) []*SeedMap {
  seedMaps := make([]*SeedMap, 0)

  for _, line := range lines {
    if strings.Index(line, ":") >= 0 { continue }

    seedMap := new(SeedMap)

    for i, part := range strings.Fields(line) {
      value, _ := strconv.Atoi(part)

      switch i {
      case 0:
        seedMap.dst = value
      case 1:
        seedMap.src = value
      case 2:
        seedMap.rng = value
      }
    }

    seedMaps = append(seedMaps, seedMap)
  }

  return seedMaps
}
