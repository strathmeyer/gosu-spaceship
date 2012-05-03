class Honeybun
  attr_reader :x, :y, :speed

  def initialize(window)
  	@img = Gosu::Image.new(window, "honeybun_small.png", false)

    @speed = 5
    @angle = rand(360)

  	@x = rand(window.width)
    @y = rand(window.height)

    @window = window
  end

  def draw
    _draw
  end

  def _draw(color=nil)
    x = @x - @img.width / 2
    y = @y - @img.height / 2
    z = ZOrder::Items

    if color then
      @img.draw(x, y, z, 1, 1, color)
    else
      @img.draw(x, y, z)
    end
  end

  def draw_color(red, green, blue)
    color = Gosu::Color.new(0xff000000)
    color.red = red
    color.green = green
    color.blue = blue

    _draw(color)
  end

  def width
  	@img.width
  end

  def height
  	@img.height
  end

  def move
    @x += Gosu::offset_x(@angle, @speed)
    @y += Gosu::offset_y(@angle, @speed)

  	stay_in_bounds
  end

  def stay_in_bounds
  	@x = @x % @window.width
  	@y = @y % @window.height
  end

  def affect_player(player)
    player.fuel = player.fuel + 2
  end

end


class EnergyHoneybun < Honeybun
  # looks blue. gives you speed.

  def draw
    draw_color(0, 0, 255)
  end

  def affect_player(player)
    player.speed = player.speed + 2

    #player.shield(5)
  end

end

class PoisonHoneybun < Honeybun
  # looks green. removes fuel.

  def draw
    draw_color(0, 255, 0)
  end

  def affect_player(player)
    if not player.shield then
      player.fuel = player.fuel - 10
      player.speed = player.speed - 3
    end
  end

end