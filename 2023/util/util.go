package util

import (
	"bufio"
	"flag"
	"os"
	"strconv"
)

type Flags struct {
	loaded   bool
	runPart1 bool
	runPart2 bool
	others   []string
}

var AoCFlags Flags

func CheckErr(e error) {
	if e != nil {
		panic(e)
	}
}

func LoadInput(path string) ([]string, error) {
	file, err := os.Open(path + "/" + inputName() + ".txt")
	CheckErr(err)

	var lines []string
	scanner := bufio.NewScanner(file)

	for scanner.Scan() {
		lines = append(lines, scanner.Text())
	}

	return lines, scanner.Err()
}

func (f *Flags) HasFlag(flag string) bool {
	GetFlags()

	switch flag {
	case "runPart1":
		return f.runPart1
	case "runPart2":
		return f.runPart2
	}

	for _, other := range f.others {
		if flag == other {
			return true
		}
	}

	return false
}

func GetFlags() Flags {
	if AoCFlags.loaded {
		return AoCFlags
	}

	// Some days may limit running examples in cases where an algorithm is inefficient.
	runPart1 := flag.Bool("run-part1", false, "Force running Part 1 solution that has been skipped by default.")
	runPart2 := flag.Bool("run-part2", false, "Force running Part 2 solution that has been skipped by default.")

	flag.Parse()

	AoCFlags = Flags{loaded: true, runPart1: *runPart1, runPart2: *runPart2, others: flag.Args()}

	return AoCFlags
}

func inputName() string {
	GetFlags()

	if len(AoCFlags.others) > 0 {
		return AoCFlags.others[0]
	}

	return "prompt"
}

func ForceInt(s string) int {
	i, err := strconv.Atoi(s)

	if err != nil {
		panic(s)
	}

	return i
}
