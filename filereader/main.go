package filereader

import (
  "bufio"
  "log"
  "os"
)

func Lines(filename string) []string {
  file, err := os.Open(filename)
  if err != nil {
    log.Fatal(err)
  }
  defer file.Close()

  var lines []string

  scanner := bufio.NewScanner(file)
  for scanner.Scan() {
    lines = append(lines, scanner.Text())
  }

  return lines
}
