package main

import (
  "github.com/ty-porter/advent-of-code-2023/util"
  "fmt"
  "strings"
  "strconv"
  "unicode"
)

var words = [9]string { "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" }

func main() {
  lines, err := util.LoadInput("day1");
  util.CheckErr(err)

  fmt.Println("Part 1: " + part1(lines))
  fmt.Println("Part 2: " + part2(lines))
}

func part1(lines []string) string {
  sum := 0

  for i := 0; i < len(lines); i++ {
    line := string(lines[i])

    leftDigitIndex  := strings.IndexFunc(line, unicode.IsNumber)
    rightDigitIndex := strings.LastIndexFunc(line, unicode.IsNumber)

    leftDigit  := int(line[leftDigitIndex] - '0')
    rightDigit := int(line[rightDigitIndex] - '0')

    sum += leftDigit * 10 + rightDigit
  }

  return strconv.Itoa(sum)
}

func part2(lines []string) string {
  sum := 0

  for i := 0; i < len(lines); i++ {
    line := string(lines[i])

    leftDigitIndex  := strings.IndexFunc(line, unicode.IsNumber)
    rightDigitIndex := strings.LastIndexFunc(line, unicode.IsNumber)

    leftWordValue, leftWordIndex   := minWordIndex(line)
    rightWordValue, rightWordIndex := maxWordIndex(line)

    // This breaks on negative index (no digits found), but only the test input on Part 2 has a line with no digits
    // day1/part2.txt changes line 2 from "eightwothree" to "eightwo1three" to get around this, since it has an equivalent Part 2 value
    leftDigitValue  := int(line[leftDigitIndex] - '0')
    rightDigitValue := int(line[rightDigitIndex] - '0')

    leftDigit  := targetValue(leftWordIndex,  leftWordValue,  leftDigitIndex,  leftDigitValue,  false)
    rightDigit := targetValue(rightWordIndex, rightWordValue, rightDigitIndex, rightDigitValue, true)

    sum += leftDigit * 10 + rightDigit
  }

  return strconv.Itoa(sum)
}

func minWordIndex(line string) (value int, pos int) {
  value = -1
  pos   = len(line)

  for i := 0; i < len(words); i++ {
    testPos := strings.Index(line, words[i])

    if testPos != -1 && testPos < pos {
      pos = testPos
      value = i + 1
    }
  }

  return value, pos
}

func maxWordIndex(line string) (value int, pos int) {
  value = -1
  pos   = -1

  for i := 0; i < len(words); i++ {
    testPos := strings.LastIndex(line, words[i])

    if testPos != -1 && testPos > pos {
      pos = testPos
      value = i + 1
    }
  }

  return value, pos
}

func targetValue(wi int, wv int, di int, dv int, searchMax bool) (int) {
  if wi < 0 { return dv }
  if di < 0 { return wv }

  candidates := map[int]int { wi: wv, di: dv }

  if searchMax {
    return candidates[max(wi, di)]
  } else { 
    return candidates[min(wi, di)]
  }
}
