class Background
  
  def initialize(window)
    @img = Gosu::Image.new(window, "images/space.jpg", false)
    @x_factor = window.width / @img.width.to_f
    @y_factor = window.height / @img.height.to_f
  end

  def draw
    @img.draw(0, 0, ZOrder::Background, @x_factor, @y_factor)
  end

end