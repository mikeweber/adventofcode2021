package day03

import (
  "testing"
)

func TestPart1(t *testing.T) {
  result := Part1("./test.txt")
  if result != 198 {
    t.Errorf("result should be 198, was %d", result)
  }
}

func TestPart2(t *testing.T) {
  result := Part2("./test.txt")
  if result != 230 {
    t.Errorf("result should be 230, was %d", result)
  }
}

func TestBinaryToDecimal(t *testing.T) {
  result := binaryToDecimal("10101")
  if result != 21 {
    t.Errorf("result should be 21, was %d", result)
  }
}
