package day02

import (
  "weberapps.com/filereader"
  "strconv"
  "strings"
)

func Part1(filename string) int64 {
  directions := filereader.Lines(filename)
  var horiz, depth int64
  horiz, depth = 0, 0
  for _, l := range directions {
    horiz, depth = move(l, horiz, depth)
  }
  return horiz * depth
}

func Part2(filename string) int64 {
  directions := filereader.Lines(filename)
  var horiz, depth, aim int64
  horiz, depth, aim = 0, 0, 0
  for _, l := range directions {
    horiz, depth, aim = moveAim(l, horiz, depth, aim)
  }
  return horiz * depth
}

func move(cmd string, horiz int64, depth int64) (int64, int64) {
  parts := strings.SplitN(cmd, " ", 2)
  cmd = parts[0]
  distStr := parts[1]
  dist, _ := strconv.ParseInt(distStr, 0, 0)
  switch cmd {
  case "forward":
    return horiz + dist, depth
  case "down":
    return horiz, depth + dist
  case "up":
    return horiz, depth - dist
  }

  return horiz, depth
}

func moveAim(cmd string, horiz int64, depth int64, aim int64) (int64, int64, int64) {
  parts := strings.SplitN(cmd, " ", 2)
  cmd = parts[0]
  distStr := parts[1]
  dist, _ := strconv.ParseInt(distStr, 0, 0)
  switch cmd {
  case "forward":
    return horiz + dist, depth + dist * aim, aim
  case "down":
    return horiz, depth, aim + dist
  case "up":
    return horiz, depth, aim - dist
  }

  return horiz, depth, aim
}
