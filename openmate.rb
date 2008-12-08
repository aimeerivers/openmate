#!/usr/bin/env ruby

require File.expand_path(File.dirname(__FILE__) + '/required_libs.rb')

New_Menu = 1
Minimal_Quit = 4
Minimal_About = ID_ABOUT
Save_Menu = 2
Load_Menu = 3
Toggle_Whitespace = 5000
Toggle_EOL = 5001


class MainApp < App
  def on_init
    frame = AppFrame.new("OpenMate",Point.new(50, 50), Size.new(800, 600))
    frame.show(TRUE)
  end
end

app = MainApp.new
app.main_loop()
puts("back from main_loop...")
GC.start
puts("survived gc")