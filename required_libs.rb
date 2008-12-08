begin
  require 'rubygems' 
rescue LoadError
end
require 'wx'
include Wx

require File.expand_path(File.dirname(__FILE__) + '/lib/document.rb')
require File.expand_path(File.dirname(__FILE__) + '/gui/gui_frame.rb')