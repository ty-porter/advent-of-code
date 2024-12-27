package main

import (
	"fmt"
	"strconv"
	"strings"

	"github.com/ty-porter/advent-of-code/2023/util"
)

type Game struct {
	red   int
	green int
	blue  int
}

func main() {
	lines, err := util.LoadInput("day2")
	util.CheckErr(err)

	fmt.Println("Part 1: " + part1(lines))
	fmt.Println("Part 2: " + part2(lines))
}

func part1(lines []string) string {
	maxGame := Game{red: 12, green: 13, blue: 14}

	sum := 0

	for i := 0; i < len(lines); i++ {
		id, games := parseGames(lines[i])

		if isValid(games, maxGame) {
			sum += id
		}
	}

	return strconv.Itoa(sum)
}

func part2(lines []string) string {
	sum := 0

	for i := 0; i < len(lines); i++ {
		_, games := parseGames(lines[i])

		sum += calculatePower(games)
	}

	return strconv.Itoa(sum)
}

func parseGames(line string) (int, []Game) {
	games := make([]Game, 0)

	id, err := strconv.Atoi(line[strings.Index(line, " ")+1 : strings.Index(line, ":")])
	util.CheckErr(err)

	game := Game{red: 0, green: 0, blue: 0}

	save := false
	buffer := make([]byte, 0)
	var value int
	var field string

	for i := strings.Index(line, ":") + 2; i < len(line); i++ {
		c := line[i]

		if c == ';' || c == ',' {
			save = true
		} else if c == ' ' {
			value, _ = strconv.Atoi(string(buffer))
			buffer = make([]byte, 0)
		} else if i == len(line)-1 {
			save = true
			buffer = append(buffer, c)
		} else {
			buffer = append(buffer, c)
		}

		if save {
			field = string(buffer)

			switch field {
			case "red":
				game.red = value
			case "green":
				game.green = value
			case "blue":
				game.blue = value
			}

			if c == ';' || i == len(line)-1 {
				games = append(games, game)
				game = Game{red: 0, green: 0, blue: 0}
			}

			buffer = make([]byte, 0)
			save = false
		}

	}

	return id, games
}

func isValid(games []Game, maxGame Game) bool {
	for i := 0; i < len(games); i++ {
		game := games[i]

		if game.red > maxGame.red || game.green > maxGame.green || game.blue > maxGame.blue {
			return false
		}
	}

	return true
}

func calculatePower(games []Game) int {
	minRed, minGreen, minBlue := 0, 0, 0

	for i := 0; i < len(games); i++ {
		game := games[i]

		if minRed < game.red {
			minRed = game.red
		}
		if minGreen < game.green {
			minGreen = game.green
		}
		if minBlue < game.blue {
			minBlue = game.blue
		}
	}

	fmt.Println(games, minRed, minGreen, minBlue)

	return minRed * minGreen * minBlue
}
