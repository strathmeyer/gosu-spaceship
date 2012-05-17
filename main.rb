require "rubygems"
require "bundler/setup"

require 'gosu'
require_relative 'player'
require_relative 'honeybun'

module ZOrder
  Background, Items, Player, UI = *0..3
end

class GameWindow < Gosu::Window
  def initialize
  	width = 1024
  	height = 960

    # Let Gosu::Window do its magic
    super(width, height, false)

    # Set a caption
    self.caption = "The Speedy Spaceship!"
    
    # Create a player
    @player = Player.new(self, width, height)

    # Put the player in the middle of the screen
    @player.warp(width / 2, height / 2)

    # Create the honeybun list
    @honeybuns = []
    
    # Create the fuel display
    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)

    # Last update
    @last_update = 1

    @game_start = Gosu::milliseconds

    @bg = Gosu::Image.new(self, "images/couch.jpg", false)
  end
  
  def update

    # Move the player

  	if button_down? Gosu::KbLeft then
      @player.go_left
    end
    if button_down? Gosu::KbRight then
      @player.go_right
    end
    if button_down? Gosu::KbUp then
      @player.go_up
    end

    if button_down? Gosu::KbDown then
      @player.go_down
    end

    # Check for shield
    @player.update

    # Try to collect any honeybuns
    @player.collect(@honeybuns)

    # We could do something with each honeybun here
    @honeybuns.each do |h|
      # move each honeybun
      h.move 
    end

    # Call our "every_second" function every second
    seconds = Gosu::milliseconds / 1000
    if seconds > @last_update then
      every_second
      @last_update = seconds
    end

    # Exit the program if the player runs out of fuel
    if @player.fuel < 1 then
      puts "GAME OVER"

      time_played = (Gosu::milliseconds - @game_start) / 1000
      puts "You played for #{time_played} seconds."
      exit
    end

  end

  def every_second

    if @honeybuns.size < 3 then
      # select a random type of honeybun
      types = [
        Honeybun, 
        PoisonHoneybun,
        Honeybun,
        EnergyHoneybun,
        Honeybun, 
        PoisonHoneybun,
        Honeybun,
        EnergyHoneybun,
        GoldHoneybun
      ]

      @last_type ||= 0
      nexttype = types[@last_type]
      @last_type = (@last_type + 1) % types.length

      # add a honebun of that type to our list
      @honeybuns.push(nexttype.new(self))
    end

    @player.fuel = @player.fuel - 1
  end
  
  def draw
    @player.draw

    @honeybuns.each do |h|
      h.draw
    end

    @font.draw("Fuel: #{@player.fuel}   Speed: #{@player.speed}", 10, 10, ZOrder::UI)

    img_factor_x = width / @bg.width.to_f
    img_factor_y = height / @bg.height.to_f
    @bg.draw(0, 0, ZOrder::Background, img_factor_x, img_factor_y)
  end
end

window = GameWindow.new
window.show