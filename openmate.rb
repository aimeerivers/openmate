#!/usr/bin/env ruby

begin
  require 'rubygems' 
rescue LoadError
end
require 'wx'
include Wx

VERSION = "0.0.1"
Minimal_Quit = 1
Minimal_About = ID_ABOUT
Save_Menu = 2
Load_Menu = 3
Toggle_Whitespace = 5000
Toggle_EOL = 5001

class MyFrame < Frame
  def initialize(title,pos,size,style=DEFAULT_FRAME_STYLE)
    super(nil,-1,title,pos,size,style)

    set_menu_bar(setup_menu)

    tb = create_tool_bar(Wx::TB_HORIZONTAL | Wx::NO_BORDER | Wx::TB_FLAT | Wx::TB_TEXT)    

    #create status bar
    create_status_bar(2)
    
    #setup StyledTextCtrl
    @sci = Wx::StyledTextCtrl.new(self)
    
    font = Font.new(10, TELETYPE, NORMAL, NORMAL)
    @sci.style_set_font(STC_STYLE_DEFAULT, font);
    
    @ws_visible = false
    @eol_visible = false
    @sci.set_edge_mode(STC_EDGE_LINE)

    line_num_margin = @sci.text_width(STC_STYLE_LINENUMBER, "_99999")
    @sci.set_margin_width(0, line_num_margin)
    
    @sci.set_tab_width(4)
    @sci.set_use_tabs(false)
    @sci.set_tab_indents(true)
    @sci.set_back_space_un_indents(true)
    @sci.set_indent(4)
    @sci.set_edge_column(80)

    @sci.set_property("fold","1")
    @sci.set_property("fold.compact", "0")
    @sci.set_property("fold.comment", "1")
    @sci.set_property("fold.preprocessor", "1")

    @sci.set_margin_width(1, 0)
    @sci.set_margin_type(1, STC_MARGIN_SYMBOL)
    @sci.set_margin_mask(1, STC_MASK_FOLDERS)
    @sci.set_margin_width(1, 20)

    @sci.marker_define(STC_MARKNUM_FOLDER, STC_MARK_PLUS)
    @sci.marker_define(STC_MARKNUM_FOLDEROPEN, STC_MARK_MINUS)
    @sci.marker_define(STC_MARKNUM_FOLDEREND, STC_MARK_EMPTY)
    @sci.marker_define(STC_MARKNUM_FOLDERMIDTAIL, STC_MARK_EMPTY)
    @sci.marker_define(STC_MARKNUM_FOLDEROPENMID, STC_MARK_EMPTY)
    @sci.marker_define(STC_MARKNUM_FOLDERSUB, STC_MARK_EMPTY)
    @sci.marker_define(STC_MARKNUM_FOLDERTAIL, STC_MARK_EMPTY)
    @sci.set_fold_flags(16)

    @sci.set_margin_sensitive(1,1)

    evt_menu(Minimal_Quit) {onQuit}
    evt_menu(Save_Menu) {onSave}
    evt_menu(Load_Menu) {onLoad}
    evt_menu(Minimal_About) {onAbout}
    evt_menu(Toggle_Whitespace) {onWhitespace}
    evt_menu(Toggle_EOL) {onEOL}
    evt_stc_charadded(@sci.get_id) {|evt| onCharadded(evt)}
    evt_stc_marginclick(@sci.get_id) {|evt| onMarginClick(evt)}

  end
  
  def setup_menu
    menuFile = Menu.new()
    menuFile.append(Load_Menu, "&Load\tCtrl-O")
    menuFile.append(Save_Menu, "&Save\tCtrl-S")
    menuFile.append(Minimal_Quit, "E&xit\tAlt-X", "Quit this program")

    menuView = Menu.new()
    menuView.append(Toggle_Whitespace, "Show &Whitespace\tF6", "Show Whitespace", ITEM_CHECK)
    menuView.append(Toggle_EOL, "Show &End of Line\tF7", "Show End of Line characters", ITEM_CHECK)

    menuHelp = Menu.new()
    menuHelp.append(Minimal_About, "&About...\tF1", "Show about dialog")

    menuBar = MenuBar.new()
    menuBar.append(menuFile, "&File")
    menuBar.append(menuView, "&View")
    menuBar.append(menuHelp, "&Help")
    
    menuBar
  end

  def keywords
    "begin break elsif module retry unless end case next return until class ensure nil self when def false not super while alias defined? for or then yield and do if redo true else in rescue undef"
  end
  
  def status=(status)
    set_status_text(status)
  end
  
  def set_style(default_fg, default_bg, line_num_fg, line_num_bg, line_indent)
    @sci.style_set_foreground(STC_STYLE_DEFAULT, BLACK);
    @sci.style_set_background(STC_STYLE_DEFAULT, WHITE);
    @sci.style_set_foreground(STC_STYLE_LINENUMBER, LIGHT_GREY);
    @sci.style_set_background(STC_STYLE_LINENUMBER, WHITE);
    @sci.style_set_foreground(STC_STYLE_INDENTGUIDE, LIGHT_GREY);
    
    @sci.set_lexer(STC_LEX_RUBY)
    @sci.style_clear_all
    @sci.style_set_foreground(2, RED)
    @sci.style_set_foreground(3, GREEN)
    @sci.style_set_foreground(5, BLUE)
    @sci.style_set_foreground(6, BLUE)
    @sci.style_set_foreground(7, BLUE)
    #keywords defined in the keywords method
    @sci.set_key_words(0, keywords)
  end
  
  def onQuit
    close(TRUE)
  end
  
  def onSave
  end

  def onLoad
    fd = Wx::FileDialog.new(self, "Choose a file to load")
    if (fd.show_modal == Wx::ID_OK)
      File.open(fd.get_path, "r") do |f|
        @sci.set_text(f.read)
      end
    end
  end

  def onAbout
    GC.start # nice :)
    msg =  sprintf("OpenMate.\n" \
    		   "Version %s", VERSION)

    message_box(msg, "About OpenMate", OK | ICON_INFORMATION, self)

  end

  def onWhitespace
    @ws_visible = !@ws_visible
    @sci.set_view_white_space(@ws_visible ? STC_WS_VISIBLEALWAYS : STC_WS_INVISIBLE)
  end

  def onEOL
    @eol_visible = !@eol_visible
    @sci.set_view_eol(@eol_visible)
  end

  def onCharadded(evt)
    chr =  evt.get_key
    curr_line = @sci.get_current_line

    if(chr == 13)
        if curr_line > 0
          line_ind = @sci.get_line_indentation(curr_line - 1)
          if line_ind > 0
            @sci.set_line_indentation(curr_line, line_ind)
            @sci.goto_pos(@sci.position_from_line(curr_line)+line_ind)
          end
        end
    end
  end

  def onMarginClick(evt)
    line_num = @sci.line_from_position(evt.get_position)
    margin = evt.get_margin

    if(margin == 1)
      @sci.toggle_fold(line_num)
    end
  end

end

class MainApp < App
  def on_init
    frame = MyFrame.new("OpenMate",Point.new(50, 50), Size.new(450, 340))

    frame.show(TRUE)
  end
end

app = MainApp.new
app.main_loop()
puts("back from main_loop...")
GC.start
puts("survived gc")