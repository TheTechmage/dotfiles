# Author:: s__C

#
# == General options {{{
#

require "socket"

# Border size in pixel of the windows

# Window move/resize steps in pixel per keypress
set :step, 3

# Window screen border snapping
set :snap, 0

# Default starting gravity for windows (0 = gravity of last client)
set :gravity, :center

# Make transient windows urgent
set :urgent, false

# Enable respecting of size hints globally
set :resize, false

# Java
set :wmname, "LG3D"

# Font string either take from e.g. xfontsel or use xft
#set :font, "-misc-fixed-medium-r-*-*-12-*-*-*-*-*-iso10646-*"
#set :font, "xft:HeldustryFTVBasic Black:pixelsize=10"
#set :font, "xft:Mensch-8"
#set :font, "xft:M+\ 2m-9"
#set :font, "xft:Luxi\ Mono-8"
#set :font, "xft:Drift-8"
#set :font, "xft:Arial\ Black-10"
#set font, "-*-*-*-*-*-*-14-*-*-*-*-*-*-*"

# }}}
#
# == Screen {{{
#

screen 1 do
  # Add stipple to panels
  stipple false

  arch = Subtlext::Icon.new("#{ENV["HOME"]}/.icons/subtle1.xbm")

  # Content of the top panel
  top [ arch, :title, :center, :clock, :center, :spacer, :tray, :views ]

  # Content of the bottom panel
  bottom [ :mpd, :spacer, :uptime, :fuzzytime]
end
# }}}
#
#  == Styles {{{
#
style :title do
  padding     2, 10, 2, 4
  foreground  "#909090"
  background  "#151515"
  font "-*-*-*-*-*-*-14-*-*-*-*-*-*-*"
end

style :all do
	foreground "#ff0000"
end

style :views do
	padding     2, 3, 1, 4
	border_bottom "#151515", 2
	foreground  "#303030"
	background  "#151515"
	font "-*-*-*-*-*-*-14-*-*-*-*-*-*-*"
	
	style :focus do
		border_bottom "#bdf13d", 2
		foreground  "#bdf13d"
		background  "#151515"
                font "-*-*-*-*-*-*-14-*-*-*-*-*-*-*"
	end

	style :urgent do
		border_bottom "#151515", 2
		foreground  "#151515"
		background  "#ff8f00"
                font "-*-*-*-*-*-*-14-*-*-*-*-*-*-*"
	end

	style :occupied do
		border_top "#f06060", 2
		border_bottom "#000000", 0
		foreground  "#606060"
		background  "#151515"
                font "-*-*-*-*-*-*-14-*-*-*-*-*-*-*"
	end
end

style :sublets do
  padding     2, 10, 2, 4
  background  "#151515"
  font "-*-*-*-*-*-*-14-*-*-*-*-*-*-*"
  foreground "#4070dd"

	style :clock do
		foreground "#5496ff"
	end

	style :volume do
		foreground "#bdf13d"
	end

	style :mpd do
		foreground "#ff6767"
	end
end

style :separator do
  padding     2, 4, 2, 4
  foreground  "#505050"
  background  "#151515"
  font "-*-*-*-*-*-*-14-*-*-*-*-*-*-*"
  seperator "|"
end

style :clients do
  active      "#6060dd", 2
  inactive    "#151515", 2
  margin      2
  font "-*-*-*-*-*-*-14-*-*-*-*-*-*-*"
end

style :subtle do
  padding     2
  panel_top   "#151515"
  panel_bottom "#151515"
  launcher_top "#202020"
  launcher_bottom "#ff0000"
  stipple     "#757575"
  font "-*-*-*-*-*-*-14-*-*-*-*-*-*-*"
  foreground "#ff0000"
end
# }}}
#
# == Gravities {{{
#

  # Gravities
gravity :top_left,       [0, 0, 50, 50]
gravity :top_left75,     [0, 0, 50, 75]
gravity :top,            [50, 0, 100, 50]
gravity :top75,          [0, 0, 100, 75]
gravity :top_right,      [50, 0, 50, 50]
gravity :top_right75,    [50, 0, 50, 75]
gravity :left,           [0, 0, 50, 100], :horz
gravity :center,         [0, 0, 100, 100], :vert
gravity :right,          [50, 0, 50, 100], :horz
gravity :bottom_left,    [0, 50, 50, 50]
gravity :bottom_left25,  [0, 75, 50, 25]
gravity :bottom,         [0, 50, 100, 50]
gravity :bottom25,       [0, 75, 100, 25]
gravity :bottom_right,   [50, 50, 50, 50]
gravity :bottom_right25, [50, 75, 50, 25]
  # Gimp
gravity :gimp_image,     [  10,   0,  80, 100 ]
gravity :gimp_toolbox,   [   0,   0,  10, 100 ]
gravity :gimp_dock,      [  90,   0,  10, 100 ]
  # Scratchpad
gravity :scratch, [ 25, 45, 50, 20 ]
# }}}
#
# == Grabs {{{
#

# Launcher+Selector
begin
   require "#{ENV["HOME"]}/subtle-contrib/ruby/launcher.rb"

   # Set fonts
   Subtle::Contrib::Launcher.fonts = ["-misc-fixed-medium-r-*-*-14-*-*-*-*-*-iso10646-*"]
   Subtle::Contrib::Launcher.paths = [
     "/usr/bin"
   ]
   rescue LoadError => error
   puts error
end

begin
   require "#{ENV["HOME"]}/subtle-contrib/ruby/selector.rb"

   Subtle::Contrib::Selector.font =  "-misc-fixed-medium-r-*-*-14-*-*-*-*-*-iso10646-*"
   rescue LoadError => error
   puts error
end

grab "W-x" do
   Subtle::Contrib::Launcher.run
end

grab "W-y" do
  Subtle::Contrib::Selector.run
end

# Jump to view1, view2, ...
grab "W-S-1", :ViewJump1
grab "W-S-2", :ViewJump2
grab "W-S-3", :ViewJump3
grab "W-S-4", :ViewJump4
grab "W-S-5", :ViewJump5
grab "W-S-6", :ViewJump6
grab "W-S-7", :ViewJump7

# Switch current view
grab "W-1", :ViewSwitch1
grab "W-2", :ViewSwitch2
grab "W-3", :ViewSwitch3
grab "W-4", :ViewSwitch4
grab "W-5", :ViewSwitch5
grab "W-6", :ViewSwitch6
grab "W-7", :ViewSwitch7

# Select next and prev view */
grab "W-Right", :ViewNext
grab "W-Left", :ViewPrev

# Move mouse to screen1, screen2, ...
grab "W-A-1", :ScreenJump1
grab "W-A-2", :ScreenJump2
grab "W-A-3", :ScreenJump3
grab "W-A-4", :ScreenJump4

# Force reload of config and sublets
grab "W-C-r", :SubtleReload

# Force restart of subtle
grab "W-C-S-r", :SubtleRestart

# Quit subtle
grab "W-C-q", :SubtleQuit

# Move current window
grab "W-B1", :WindowMove

# Resize current window
grab "W-B3", :WindowResize

# Toggle floating mode of window
grab "A-f", :WindowFloat

# Toggle fullscreen mode of window
grab "A-space", :WindowFull

# Toggle sticky mode of window (will be visible on all views)
grab "A-s", :WindowStick

# Raise window
grab "A-r", :WindowRaise

# Lower window
grab "A-l", :WindowLower

# Select next windows
grab "C-Left", :WindowLeft
grab "C-Down", :WindowDown
grab "C-Up", :WindowUp
grab "C-Right", :WindowRight

# Kill current window
grab "A-q", :WindowKill

# Cycle between given gravities
grab "W-KP_7", [ :top_left, :top_left75 ]
grab "W-KP_8", [ :top, :top75 ]
grab "W-KP_9", [ :top_right, :top_right75 ]
grab "W-KP_4", [ :left ]
grab "W-KP_5", [ :center ]
grab "W-KP_6", [ :right ]
grab "W-KP_1", [ :bottom_left, :bottom_left25 ]
grab "W-KP_2", [ :bottom, :bottom25 ]
grab "W-KP_3", [ :bottom_right, :bottom_right25 ]

# Exec programs
grab "W-Return", "gnome-terminal"
grab "W-c", "chromium"
grab "W-h", "hotot"
grab "W-m", "urxvtc -name mutt -e mutt"
grab "W-n", "mpd && urxvtc -name ncmpcpp -e ncmpcpp || urxvtc -name ncmpcpp -e ncmpcpp"
grab "W-t", "urxvtc -name tmux -e tmux"
grab "W-a", "urxvtc -name tmux -e tmux a"
grab "W-f", "firefox"
grab "W-C-f", "filezilla"
grab "W-p", "thunar"
grab "W-r", "urxvtc -name ranger -e mc"
grab "W-v", "gvim"

# MPC grabs
grab "W-C-Right", "mpc next"
grab "W-C-Left", "mpc prev"
grab "W-C-Down", "mpc toggle"

# Scratchpad
grab "W-s" do
  if((c = Subtlext::Client["scratch"]))
    c.toggle_stick
    c.focus
  elsif((c = Subtlext::Subtle.spawn("urxvtc -name scratch")))
    c.tags  = [] 
    c.flags = [ :stick ]
  end
end

# Run Ruby lambdas
grab "S-F2" do |c|
  puts c.name
end

grab "S-F3" do
  puts Subtlext::VERSION
end
# }}}
#
# == Tags {{{
#

# Simple tags
tag "www" do
  match :class => "uzbl|iron|opera|firefox|chromium|dwb|jumanji"
end

tag "vec" do
  match :class => "inkscape|shotwell"
end

tag "vb" do
  match :class => "virtualbox"
end

tag "term" do
  match :instance => "xterm|[u]?rxvt|gnome-terminal"
  #exclude "vim|scratch|mutt|tmux|ncmpcpp|screen"
end

tag "vim" do
  match :class => "gvim"
  gravity :center
end

tag "tmux" do
  match :instance => "tmux|screen"
  gravity :top75
end

tag "mpd" do
  match :instance => "ncmpcpp"
  gravity :bottom25
end

tag "mail" do
  match :instance => "mutt"
end

tag "scratchpad" do
  match :instance => "scratch"
  gravity :scratch
  urgent true
  stick true
end

tag "default" do
  gravity :center33
end

tag "fm" do
  match :class => "thunar"
  gravity :top75
end

tag "tor" do
	match :class => "deluge"
	gravity :bottom25
end

tag "matlab" do
  match :class => ".*mat(lab|hworks).*"
	full true
end

tag "flash" do
  match :class => "<unkown>|exe|operapluginwrapper"
  stick true
end

tag "editor" do
  match :class => "gedit|texmaker|eclipse|geany"
  resize false
end

tag "view" do
  match :class => "zathura|evince"
  float true
  resize true
end

tag "fixed" do
  geometry [ 10, 10, 100, 100 ]
  stick true
end

tag "resize" do
  match :class => "sakura|gedit"
  resize true
end

# Modes
tag "stick" do
  match :instance => "mplayer|ranger"
  float true
  stick true
end

tag "float" do
  match "display"
  float true
end

# Gimp
tag "gimp_image" do
  match :role => "gimp-image-window"
  gravity :gimp_image
end

tag "gimp_toolbox" do
  match :role => "gimp-toolbox$"
  gravity :gimp_toolbox
end

tag "gimp_dock" do
  match :role => "gimp-dock"
  gravity :gimp_dock
end

tag "dialogs" do
  match :type => :dialog
  match :type => :splash
	center true
  stick true
end
# }}}
#
# == Views {{{
#

view "term" do
  match "term|mpd|tmux|gnome-terminal"
  dynamic false
  icon "#{ENV["HOME"]}/.icons/icons/terminal.xbm"
  icon_only true
end

view "www" do
  match "www"
  dynamic false
  icon "#{ENV["HOME"]}/.icons/icons/world.xbm"
  icon_only true
end

view "stuff" do
  match "default|hotot|fm|tor"
  dynamic false
  icon "#{ENV["HOME"]}/.icons/icons/quote.xbm"
  icon_only true
end

view "dev" do
  match "editor|vim"
  dynamic false
  icon "#{ENV["HOME"]}/.icons/icons/notepad.xbm"
  icon_only true
end


view "design" do
  match "vec|gimp_.*"
  dynamic false
  icon "#{ENV["HOME"]}/.icons/icons/diagram.xbm"
  icon_only true
end

view "vbox" do
  match "vb"
  dynamic false
  icon "#{ENV["HOME"]}/.icons/icons/pc.xbm"
  icon_only true
end

view "prog" do
  match "matlab"
  dynamic true
end
# }}}
#
# Sublets {{ {
#

sublet :clock do
  format_string "%d.%m.%y %H:%M"
end

sublet :mpd do
  format_string "%note% %artist% - %album% - %title%"
	show_icons false
	pause_text "pause"
	not_running_text "--"
end
# }}}
