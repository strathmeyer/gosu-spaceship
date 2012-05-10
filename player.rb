class Player
  MAX_SPEED = 20
  MAX_FUEL = 100
  
  attr_reader :x, :y, :speed, :fuel

  def initialize(window, max_x, max_y)
    @window = window
    @image = Gosu::Image.new(window, "spaceship.png", false)
    @x = 0.0
    @y = 0.0
    @max_x = max_x
    @max_y = max_y
    @fuel = 50
    @speed = 10
  end

  def warp(x, y)
    @x, @y = x, y
  end

  def speed=(s)
    @speed = [s, MAX_SPEED].min
    @speed = [s, 5].max
  end

  def fuel=(s)
    @fuel = [s, MAX_FUEL].min
    @fuel = [s, 0].max
  end

  def update
    if @shield_timeout and Gosu::milliseconds > @shield_timeout then
      @shield_timeout = nil
      @shield = false
    end
  end

  def shield(seconds=nil)
    unless seconds
      return @shield
    end

    @shield = true
    @shield_timeout = Gosu::milliseconds + (1000 * seconds)
  end

  def go_right
    @x = @x + @speed
    stay_in_bounds
  end

  def go_left
    @x = @x - @speed
    stay_in_bounds
  end

  def go_up
    @y = @y - @speed
    stay_in_bounds
  end

  def go_down
    @y = @y + @speed
    stay_in_bounds
  end

  def stay_in_bounds
    @x = @x % @window.width
    @y = @y % @window.height
  end
  
  def draw
    if @shield then
      @image.draw_rot(@x, @y, ZOrder::Player, 0, 0.5, 0.5, 1, 1, 0xFF0000FF)
    else
      @image.draw_rot(@x, @y, ZOrder::Player, 0)
    end
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