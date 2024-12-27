package main

import (
	"fmt"
	"strconv"
	"strings"

	"github.com/ty-porter/advent-of-code/2023/util"
)

const target = "ZZZ"

type Node struct {
	name  string
	left  string
	right string
}

func main() {
	lines, err := util.LoadInput("day8")
	util.CheckErr(err)

	nodes := make(map[string]Node)
	directions := lines[0]

	startingNodes := makeNodes(nodes, lines[2:len(lines)])

	fmt.Println("Part 1: " + part1(directions, nodes))
	fmt.Println("Part 2: " + part2(directions, startingNodes, nodes))
}

func part1(directions string, nodes map[string]Node) string {
	node := nodes["AAA"]

	i := 0
	var d rune

	for {
		d = rune(directions[i%len(directions)])

		if node.name == target {
			break
		}

		switch d {
		case 'L':
			node = nodes[node.left]
		case 'R':
			node = nodes[node.right]
		}

		i++
	}

	return strconv.Itoa(i)
}

func part2(directions string, currentNodes []Node, nodes map[string]Node) string {
	i := 0
	var d rune

	loopSizes := make([]int, len(currentNodes))

	for {
		d = rune(directions[i%len(directions)])
		targetCount := 0

		for j, node := range currentNodes {
			if node.name[2] == target[2] {
				targetCount++
				if loopSizes[j] == 0 {
					loopSizes[j] = i
				}
			}

			switch d {
			case 'L':
				currentNodes[j] = nodes[node.left]
			case 'R':
				currentNodes[j] = nodes[node.right]
			}
		}

		loopCount := 0
		for _, v := range loopSizes {
			if v > 0 {
				loopCount++
			}
		}

		if targetCount == len(currentNodes) || loopCount == len(loopSizes) {
			break
		}

		i++
	}

	loopLcm := 1
	for _, size := range loopSizes {
		loopLcm = lcm(loopLcm, size)
	}

	return strconv.Itoa(loopLcm)
}

func makeNodes(nodes map[string]Node, lines []string) []Node {
	startingNodes := make([]Node, 0)

	for _, line := range lines {
		parts := strings.Fields(line)

		name := parts[0]
		left := parts[2][1 : len(parts[2])-1]
		right := parts[3][0 : len(parts[3])-1]

		nodes[name] = Node{name: name, left: left, right: right}

		if name[len(name)-1] == 'A' {
			startingNodes = append(startingNodes, nodes[name])
		}
	}

	return startingNodes
}

func gcd(a, b int) int {
	for b != 0 {
		t := b
		b = a % b
		a = t
	}
	return a
}

func lcm(a, b int) int {
	return a * b / gcd(a, b)
}
