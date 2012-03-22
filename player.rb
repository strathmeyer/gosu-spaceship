class Player
  IMAGE_ROT = 38
  SPEED = 5

  def initialize(window, max_x, max_y)
    @image = Gosu::Image.new(window, "spaceship.png", false)
    @x = 0.0
    @y = 0.0
    @max_x = max_x
    @max_y = max_y
  end

  def warp(x, y)
    @x, @y = x, y
  end

  def go_right
    @x = @x + SPEED
  end

  def go_left
    @x = @x - SPEED
  end

  def go_up
    @y = @y - SPEED
  end

  def go_down
    @y = @y + SPEED
  end

  
  def check
    # Make sure the spaceship stays in bounds

    @x = [@x, @max_x].min
    @x = [@x, 0].max
    @y = [@y, @max_y].min
    @y = [@y, 0].max
  end

  def draw
    @image.draw_rot(@x, @y, 1, IMAGE_ROT)
  end
end