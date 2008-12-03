#!/usr/bin/env ruby

begin
  require 'rubygems' 
rescue LoadError
end
require 'wx'
require 'gui/gui_frame'
include Wx

VERSION = "0.0.1"
Minimal_Quit = 1
Minimal_About = ID_ABOUT
Save_Menu = 2
Load_Menu = 3
Toggle_Whitespace = 5000
Toggle_EOL = 5001


class MainApp < App
  def on_init
    frame = AppFrame.new("OpenMate",Point.new(50, 50), Size.new(500, 500))
    frame.show(TRUE)
  end
end

app = MainApp.new
app.main_loop()
puts("back from main_loop...")
GC.start
puts("survived gc")