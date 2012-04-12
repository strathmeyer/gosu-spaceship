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
    @player.warp(20, 20)

    # Create a honeybun
    @honeybuns = []
    
    # Create the fuel display
    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)

    # Last update
    @last_update = 1
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

    @player.collect(@honeybuns)

    # Call our "ever_second" function every ten seconds
    seconds = Gosu::milliseconds / 1000
    if seconds > @last_update then
      every_second
      @last_update = seconds
    end

    # Exit the program if the player runs out of fuel
    if @player.fuel < 1 then
      puts "YOU LOSE"
      exit
    end

  end

  def every_second
    if @honeybuns.empty? then
      @honeybuns.push(Honeybun.new(self))
    end

    @player.fuel = @player.fuel - 1
  end
  
  def draw
    @player.draw

    @honeybuns.each do |h|
      h.draw
    end

    @font.draw("Fuel: #{@player.fuel}", 10, 10, ZOrder::UI)
  end
end

window = GameWindow.new
window.show