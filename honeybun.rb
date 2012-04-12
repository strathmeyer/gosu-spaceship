class Honeybun
  attr_reader :x, :y

  def initialize(window)
  	@img = Gosu::Image.new(window, "honeybun.png", false)

  	@x = (window.width / 2)
    @y = (window.height / 2)
  end

  def draw
    @img.draw(@x - @img.width / 2, @y - @img.height / 2, ZOrder::Items)
  end

  def affect_player(player)
  	player.fuel = player.fuel + 5
  end

  def width
  	@img.width
  end

  def height
  	@img.height
  end
end