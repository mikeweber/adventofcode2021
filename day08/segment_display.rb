class SegmentDisplay
  attr_reader :wire_map

  def initialize(wire_order)
    @wire_map = {}
    wire_order.zip(%w[a b c d e f g]).each do |wire, display|
      wire_map[wire] = display
    end
  end

  def display(segments)
    segments = segments.split("").map { |x| wire_map[x] }
    if segments.include?("a")
      show_a
    else
      hide_a
    end

    if segments.include?("b")
      if segments.include?("c")
        show_b_and_c
      else
        show_b
      end
    else
      if segments.include?("c")
        show_c
      else
        hide_b_and_c
      end
    end

    if segments.include?("d")
      show_d
    else
      hide_d
    end

    if segments.include?("e")
      if segments.include?("f")
        show_e_and_f
      else
        show_e
      end
    else
      if segments.include?("f")
        show_f
      else
        hide_e_and_f
      end
    end

    if segments.include?("g")
      show_g
    else
      hide_g
    end
  end

  def show_a
    puts " #### "
  end

  def hide_a
    puts " .... "
  end

  def show_b
    puts "#    ."
    puts "#    ."
  end

  def show_c
    puts ".    #"
    puts ".    #"
  end

  def show_b_and_c
    puts "#    #"
    puts "#    #"
  end

  def hide_b_and_c
    puts ".    ."
    puts ".    ."
  end

  def show_d
    puts " #### "
  end

  def hide_d
    puts " .... "
  end

  def show_e
    puts "#    ."
    puts "#    ."
  end

  def show_f
    puts ".    #"
    puts ".    #"
  end

  def show_e_and_f
    puts "#    #"
    puts "#    #"
  end

  def hide_e_and_f
    puts ".    ."
    puts ".    ."
  end

  def show_g
    puts " #### "
  end

  def hide_g
    puts " .... "
  end
end
