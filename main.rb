require 'gosu'

module ZOrder
  Stars = 1
  Spaceship = 2
end

class Player
  IMAGE_ROT = 38

  def initialize(window, max_x, max_y)
    @image = Gosu::Image.new(window, "spaceship.png", false)
    @x = @y = @vel_x = @vel_y = @angle = 0.0
    @max_x = max_x
    @max_y = max_y
  end

  def warp(x, y)
    @x, @y = x, y
  end
  
  def turn_left
    @angle -= 4.5
  end
  
  def turn_right
    @angle += 4.5
  end
  
  def accelerate
    @vel_x += Gosu::offset_x(@angle, 0.5)
    @vel_y += Gosu::offset_y(@angle, 0.5)
  end

  def decelerate
    @vel_x *= 0.95
    @vel_y *= 0.95
  end
  
  def move
    @x += @vel_x
    @y += @vel_y

    # @x = [@x, @max_x].min
    # @x = [@x, 0].max
    # @y = [@y, @max_y].min
    # @y = [@y, 0].max
    
    @x = @x % @max_x
    @y = @y % @max_y

    @vel_x *= 0.99
    @vel_y *= 0.99
  end

  def draw
    @image.draw_rot(@x, @y, ZOrder::Spaceship, @angle + IMAGE_ROT)
  end

  def collect_stars(stars)
    stars.reject! do |star|
      Gosu::distance(@x, @y, star.x, star.y) < 35 
    end
  end
end

class Star
  attr_reader :x, :y

  def initialize(img)
    @img = img
    @color = Gosu::Color.new(0xff000000)
    @color.red = rand(256 - 40) + 40
    @color.green = rand(256 - 40) + 40
    @color.blue = rand(256 - 40) + 40
    @x = rand * 1024
    @y = rand * 960
  end

  def draw
    @img.draw(@x - @img.width / 2.0, @y - @img.height / 2.0,
        ZOrder::Stars, 1, 1) #, @color, :add)
  end
end

class GameWindow < Gosu::Window
  def initialize
  	width = 1024
  	height = 960

    super(width, height, false)
    self.caption = "The Speedy Spaceship!"
    
    @player = Player.new(self, width, height)
    @player.warp(width/2, height/2)

    @star_img = Gosu::Image.new(self, "star.png", false)
    @stars = Array.new
  end
  
  def update
  	if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft then
      @player.turn_left
    end
    if button_down? Gosu::KbRight or button_down? Gosu::GpRight then
      @player.turn_right
    end
    if button_down? Gosu::KbUp or button_down? Gosu::GpButton0 then
      @player.accelerate
    end
    if button_down? Gosu::KbDown or button_down? Gosu::GpButton1 then
      @player.decelerate
    end

    @player.move
    @player.collect_stars(@stars)

    if rand(100) < 4 and @stars.size < 25 then
      @stars.push(Star.new(@star_img))
    end
  end
  
  def draw
    @player.draw
    @stars.each { |s| s.draw }
  end
end

window = GameWindow.new
window.show