class Player
  IMAGE_ROT = 38
  SPEED = 5

  attr_accessor :fuel
  attr_reader :x, :y

  def initialize(window, max_x, max_y)
    @window = window
    @image = Gosu::Image.new(window, "spaceship.png", false)
    @x = 0.0
    @y = 0.0
    @max_x = max_x
    @max_y = max_y
    @fuel = 50
  end

  def warp(x, y)
    @x, @y = x, y
  end

  def go_right
    @x = @x + SPEED
    stay_in_bounds
  end

  def go_left
    @x = @x - SPEED
    stay_in_bounds
  end

  def go_up
    @y = @y - SPEED
    stay_in_bounds
  end

  def go_down
    @y = @y + SPEED
    stay_in_bounds
  end

  def stay_in_bounds
    @x = @x % @window.width
    @y = @y % @window.height
  end
  
  def draw
    @image.draw_rot(@x, @y, ZOrder::Player, IMAGE_ROT)
  end

  def collect(items)
    items.each do |item|
      distance = Gosu::distance(self.x, self.y, item.x, item.y)

      if (distance < item.width / 2) then
        items.delete item

        if item.respond_to? :affect_player then
          item.affect_player(self)
        end
      end
      
    end 
  end

end