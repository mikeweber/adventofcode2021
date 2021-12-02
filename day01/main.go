package day01

import (
  "bufio"
  "os"
  "strconv"
)

func Part1(filename string) int {
  file, _ := os.Open(filename)

  var depths []int64
  scanner := bufio.NewScanner(file)
  for scanner.Scan() {
    i, _ := strconv.ParseInt(scanner.Text(), 0, 0)
    depths = append(depths, i)
  }
  defer file.Close()
  return countIncreases(depths)
}

func Part2(filename string) int {
  file, _ := os.Open(filename)

  var depths []int64
  scanner := bufio.NewScanner(file)
  for scanner.Scan() {
    i, _ := strconv.ParseInt(scanner.Text(), 0, 0)
    depths = append(depths, i)
  }
  defer file.Close()
  return countSlidingIncreases(depths)
}

func countIncreases(a []int64) int {
  increases := 0
  for i := 1; i < len(a); i++ {
    if a[i - 1] < a[i] {
      increases++
    }
  }
  return increases
}

func countSlidingIncreases(a []int64) int {
  increases := 0
  for i := 3; i < len(a); i++ {
    prevWindow := a[i - 3] + a[i - 2] + a[i - 1]
    curWindow  := a[i - 2] + a[i - 1] + a[i]
    if prevWindow < curWindow {
      increases++
    }
  }
  return increases
}
