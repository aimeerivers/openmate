require 'rubygems'
require 'wx'
include Wx

class MainAppFrame < Frame
  def initialize()
       super(nil, -1, "OpenMate")
       textarea = TextCtrl.new(parent, :style => TE_MULTILINE)       
       show()
   end
end

class MainApp < App
  def on_init
    MainAppFrame.new
  end
end

MainApp.new.main_loop()