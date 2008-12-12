#!/usr/bin/env ruby

require File.expand_path(File.dirname(__FILE__) + '/required_libs.rb')

New_Menu = 1
Minimal_Quit = 4
Minimal_About = ID_ABOUT
Save_Menu = 2
Open_Menu = 3
Toggle_Whitespace = 5000
Toggle_EOL = 5001


class MainApp < App
  def on_init
    #Opens OpenMate up at 80% of the screensize
    screen_x = Wx::SystemSettings.get_metric(Wx::SYS_SCREEN_X) * 0.80
    screen_y = Wx::SystemSettings.get_metric(Wx::SYS_SCREEN_Y) * 0.80
    frame = AppFrame.new("OpenMate",Point.new(50, 50), Size.new(screen_x.to_i , screen_y.to_i))
    frame.show(TRUE)
  end
end

app = MainApp.new
app.main_loop()
puts("back from main_loop...")
GC.start
puts("survived gc")