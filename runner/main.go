package main

import (
  "fmt"
  "os"
  "weberapps.com/day01"
  "weberapps.com/day02"
  "weberapps.com/day03"
)

func main() {
  prog := os.Args[1]
  switch prog {
  case "01a":
    fmt.Println(day01.Part1("../day01/input"))
  case "01b":
    fmt.Println(day01.Part2("../day01/input"))
  case "02a":
    fmt.Println(day02.Part1("../day02/input"))
  case "02b":
    fmt.Println(day02.Part2("../day02/input"))
  case "03a":
    fmt.Println(day03.Part1("../day03/input"))
  default:
    fmt.Println("Unrecognized command: ", prog)
  }
}
