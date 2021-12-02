package day01

import (
  "testing"
)

func TestDepthHasIncreased(t *testing.T) {
  result := countIncreases([]int64{1, 3})
  if result != 1 {
    t.Errorf("Expected 1 increase, got %d", result)
  }
}

func TestDepthHasRemainedSteady(t *testing.T) {
  result := countIncreases([]int64{1, 1})
  if result != 0 {
    t.Errorf("Expected 0 increase, got %d", result)
  }
}

func TestDepthHasDeclined(t *testing.T) {
  result := countIncreases([]int64{2, 1})
  if result != 0 {
    t.Errorf("Expected 0 increase, got %d", result)
  }
}

func TestSmallCase(t *testing.T) {
  a := []int64{
    199,
    200,
    208,
    210,
    200,
    207,
    240,
    269,
    260,
    263,
  }

  result := countIncreases(a)
  if result != 7 {
    t.Errorf("Expected 7 increase, got %d", result)
  }
}

func TestSlidingScaleIncreases(t *testing.T) {
  result := countSlidingIncreases([]int64{2, 3, 4, 5})
  if result != 1 {
    t.Errorf("Expected 1 increase, got %d", result)
  }
}

func TestSlidingScaleRemainsSteady(t *testing.T) {
  result := countSlidingIncreases([]int64{2, 3, 4, 2})
  if result != 0 {
    t.Errorf("Expected 0 increase, got %d", result)
  }
}

func TestSlidingScaleDeclines(t *testing.T) {
  result := countSlidingIncreases([]int64{2, 3, 4, 1})
  if result != 0 {
    t.Errorf("Expected 0 increase, got %d", result)
  }
}
