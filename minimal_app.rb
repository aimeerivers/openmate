require 'rubygems'
require 'wx'
include Wx 


class MinimalApp < App
  def on_init
    Frame.new(nil, -1, "The Bare Minimum").show()
  end
end

MinimalApp.new.main_loop

