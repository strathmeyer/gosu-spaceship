require "rubygems"
require "bundler/setup"

require 'gosu'
require_relative 'player'

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
    @player.warp(width/2, height/2)
  end
  
  def update
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

    end

    # Make sure the spaceship stays in bounds
    @player.check

  end
  
  def draw
    @player.draw
  end
end

window = GameWindow.new
window.show