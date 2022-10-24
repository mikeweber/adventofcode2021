package day02

import (
  "testing"
)

func TestForward(t *testing.T) {
  horiz, depth := move("forward 5", 0, 0)
  if horiz != 5 {
    t.Errorf("Expected to move forward 5, moved forward %d", horiz)
  }
  if depth != 0 {
    t.Errorf("Depth should not have changed, changed to %d", depth)
  }
}

func TestDown(t *testing.T) {
  horiz, depth := move("down 3", 0, 0)
  if horiz != 0 {
    t.Errorf("Expected to not move forward, moved forward %d", horiz)
  }
  if depth != 3 {
    t.Errorf("Depth should have changed to 3, but changed to %d", depth)
  }
}

func TestUp(t *testing.T) {
  horiz, depth := move("up 6", 0, 10)
  if horiz != 0 {
    t.Errorf("Expected to not move forward, moved forward %d", horiz)
  }
  if depth != 4 {
    t.Errorf("Depth should have changed to 4, but changed to %d", depth)
  }
}

func TestPart1(t *testing.T) {
  result := Part1("./test.txt")
  if result != 150 {
    t.Errorf("Result should have been 150, got %d", result)
  }
}

func TestForwardAim(t *testing.T) {
  horiz, depth, aim := moveAim("forward 3", 10, 10, 5)
  if horiz != 13 {
    t.Errorf("Expected to move forward to 13, but moved to %d", horiz)
  }
  if depth != 25 {
    t.Errorf("Depth should have changed to 25, but changed to %d", depth)
  }

  if aim != 5 {
    t.Errorf("Aim should not have changed from 5, changed to %d", aim)
  }
}

func TestDownAim(t *testing.T) {
  horiz, depth, aim := moveAim("down 3", 10, 10, 5)
  if horiz != 10 {
    t.Errorf("Expected to not move forward from 10, but moved to %d", horiz)
  }
  if depth != 10 {
    t.Errorf("Depth should not have changed from 10, but changed to %d", depth)
  }

  if aim != 8 {
    t.Errorf("Aim should have changed to 8, changed to %d", aim)
  }
}

func TestUpAim(t *testing.T) {
  horiz, depth, aim := moveAim("up 3", 10, 10, 4)
  if horiz != 10 {
    t.Errorf("Expected to not move forward from 10, but moved to %d", horiz)
  }
  if depth != 10 {
    t.Errorf("Depth should not have changed from 10, but changed to %d", depth)
  }

  if aim != 1 {
    t.Errorf("Aim should have changed to 1, changed to %d", aim)
  }
}

func TestPart2(t *testing.T) {
  result := Part2("./test.txt")
  if result != 900 {
    t.Errorf("Result should have been 900, got %d", result)
  }
}
