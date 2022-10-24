package day03

import (
  "fmt"
  "math"
  "weberapps.com/filereader"
)

func Part1(filename string) int64 {
  diagnostics := filereader.Lines(filename)
  bit_length := len(diagnostics[0])
  one_counts := createMap(bit_length)
  for _, line := range diagnostics {
    for i, char := range line {
      if char == '1' {
        var position_val = int64(math.Pow(2, float64(bit_length - i - 1)))
        one_counts[position_val] += 1
      }
    }
  }
  var gamma, epsilon int64 = 0, 0
  for key, count := range one_counts {
    if count >= len(diagnostics) / 2 {
      gamma += key
    } else {
      epsilon += key
    }
  }
  return gamma * epsilon
}

func Part2(filename string) int64 {
  diagnostics := filereader.Lines(filename)
  fmt.Println(diagnostics)
  bit_length := len(diagnostics[0])
  o2Readings := diagnoseLifeSupport(diagnostics, 0, bit_length, '1', 0)
  co2Readings := diagnoseLifeSupport(diagnostics, 0, bit_length, '0', 0)

  return o2Readings * co2Readings
}

func diagnoseLifeSupport(diagnostics []string, pos int, bit_size int, matcher rune, result int64) int64 {
  if len(diagnostics) == 0 {
    return result
  }
  if len(diagnostics) == 1 {
    return binaryToDecimal(diagnostics[0])
  }

  matches := make([]string, 0)
  mismatches := make([]string, 0)
  for _, line := range diagnostics {
    fmt.Println(line)
    chars := []rune(line)
    if chars[pos] == matcher {
      matches = append(matches, line)
    } else {
      mismatches = append(mismatches, line)
    }
  }
  if len(matches) >= len(mismatches) {
    result = diagnoseLifeSupport(matches, pos + 1, bit_size, matcher, result)
  } else {
    result = diagnoseLifeSupport(mismatches, pos + 1, bit_size, matcher, result)
  }
  return result
}

func binaryToDecimal(binary string) int64 {
  var result float64 = 0
  for i := 0; i < len(binary); i++ {
    if binary[i] == '1' {
      result += math.Pow(2, float64(len(binary) - i - 1))
    }
  }
  return int64(result)
}

func createMap(size int) map[int64]int {
  one_counts := make(map[int64]int, size)
  for pos := 0; pos < size; pos++ {
    var position_val = int64(math.Pow(2, float64(size - pos - 1)))
    one_counts[position_val] = 0
  }
  return one_counts
}
