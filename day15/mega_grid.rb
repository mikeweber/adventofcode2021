require_relative "../day09/grid"

class MegaGrid < Grid
  attr_reader :step_size, :base_width, :base_height

  def initialize(matrix, size_multiplier: 5, step_size: 1)
    @matrix = matrix
    @base_width = matrix[0].size
    @base_height = matrix.size
    @width = base_width * size_multiplier
    @height = base_height * size_multiplier
    @step_size = step_size
  end

  def [](pos)
    return unless valid_position?(pos)

    factor = pos.x / base_width + pos.y / base_height
    ((matrix[pos.y % base_height][pos.x % base_width] - 1) + step_size * factor) % 9 + 1
  end
end
