require File.expand_path(File.dirname(__FILE__) + '/../required_libs.rb')

class AppFrame < Frame
  def initialize(title,pos,size,style=DEFAULT_FRAME_STYLE)
    super(nil,-1,title,pos,size,style)
    
    @version = "0.0.1"
    set_menu_bar(setup_menu)

    tb = create_tool_bar(Wx::TB_HORIZONTAL | Wx::NO_BORDER | Wx::TB_FLAT | Wx::TB_TEXT)    

    #create status bar
    create_status_bar(2)
    set_status_text("Welcome to OpenMate!")
    
    #setup notebook for tabs
    @notebook = Wx::Notebook.new(self,-1, pos, size)
    
    @ws_visible = false
    @eol_visible = false    
    
    evt_menu(Minimal_Quit) {onQuit}
    evt_menu(New_Menu) {onNew}
    evt_menu(Save_Menu) {onSave}
    evt_menu(Load_Menu) {onLoad}
    evt_menu(Minimal_About) {onAbout}
    evt_menu(Toggle_Whitespace) {onWhitespace}
    evt_menu(Toggle_EOL) {onEOL}
    evt_stc_charadded(self.get_id) {|evt| onCharadded(evt)}
    evt_stc_marginclick(self.get_id) {|evt| onMarginClick(evt)}
    
  end
  
  def setup_menu
    menuFile = Menu.new()
    menuFile.append(New_Menu, "&New\tCtrl-N")
    menuFile.append(Load_Menu, "&Load\tCtrl-O")
    menuFile.append(Save_Menu, "&Save\tCtrl-S")
    menuFile.append(Minimal_Quit, "E&xit\tAlt-X", "Quit this program")

    menuView = Menu.new()
    menuView.append(Toggle_Whitespace, "Show &Whitespace\tF6", "Show Whitespace", ITEM_CHECK)
    menuView.append(Toggle_EOL, "Show &End of Line\tF7", "Show End of Line characters", ITEM_CHECK)
    set_style_light = menuView.append("View style - Light", "Set view style to light")
    set_style_dominion = menuView.append("View style - Dominion", "Set view style to Dominion")
    
    evt_menu(set_style_light) { @document.set_view_style('Light') }
    evt_menu(set_style_dominion) { @document.set_view_style('Dominion') }

    menuHelp = Menu.new()
    menuHelp.append(Minimal_About, "&About...\tF1", "Show about dialog")

    menuBar = MenuBar.new()
    menuBar.append(menuFile, "&File")
    menuBar.append(menuView, "&View")
    menuBar.append(menuHelp, "&Help")
    
    menuBar
  end
  
  def status=(status)
    set_status_text(status)
  end
  
  def new_tab=(filename)
    
  end
  
  def onQuit
    close(TRUE)
  end
  
  def onNew
    #setup StyledTextCtrl and add to notebook
    @document = Document.new(@notebook)
    
    #create a tab with title page for now
    @notebook.add_page(@document, @document.file_name)
    
    #set styles
    @document.set_style({})
  end
  
  def onSave
  end

  def onLoad
    fd = Wx::FileDialog.new(self, "Choose a file to load")
    if (fd.show_modal == Wx::ID_OK)
      File.open(fd.get_path, "r") do |f|
        @document.set_text(f.read)
        @notebook.add_page(@document, File.basename(fd.get_path), true)
      end
    end
  end

  def onAbout
    GC.start # nice :)
    msg =  sprintf("OpenMate.\n" + "Version #{@version}")

    message_box(msg, "About OpenMate", OK | ICON_INFORMATION, self)
  end

  def onWhitespace
    @ws_visible = !@ws_visible
    @document.set_view_white_space(@ws_visible ? STC_WS_VISIBLEALWAYS : STC_WS_INVISIBLE)
  end

  def onEOL
    @eol_visible = !@eol_visible
    @document.set_view_eol(@eol_visible)
  end

  def onCharadded(evt)
    chr =  evt.get_key
    curr_line = @document.get_current_line

    if(chr == 13)
        if curr_line > 0
          line_ind = @document.get_line_indentation(curr_line - 1)
          if line_ind > 0
            @document.set_line_indentation(curr_line, line_ind)
            @document.goto_pos(@document.position_from_line(curr_line)+line_ind)
          end
        end
    end
  end

  def onMarginClick(evt)
    line_num = @document.line_from_position(evt.get_position)
    margin = evt.get_margin

    if(margin == 1)
      @document.toggle_fold(line_num)
    end
  end

end
