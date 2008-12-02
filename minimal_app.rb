require 'rubygems'
require 'wx' 


class MinimalApp < Wx::App
  def on_init
    frame = Wx::Frame.new(nil, -1, "The Bare Minimum").show()
    frame.show
  end
end

MinimalApp.new.main_loop

