package main

import (
  "fmt"
  "os"
  "weberapps.com/day01"
)

func main() {
  prog := os.Args[1]
  switch prog {
  case "01a":
    fmt.Println(day01.Part1("../day01/input"))
  case "01b":
    fmt.Println(day01.Part2("../day01/input"))
  default:
    fmt.Println("Unrecognized command: %s", prog)
  }
}
