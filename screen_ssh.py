#!/usr/bin/env python
# -*- coding: utf-8 -*-

from time import sleep
import curses, os, sys


screen = curses.initscr()
curses.noecho()
curses.cbreak()
curses.start_color()
screen.keypad(True)
curses.init_pair(1,curses.COLOR_BLACK, curses.COLOR_WHITE)
h = curses.color_pair(1)
n = curses.A_NORMAL

curses.init_pair(2,curses.COLOR_RED, curses.COLOR_BLACK)
red = curses.color_pair(2)
curses.init_pair(3,curses.COLOR_GREEN, curses.COLOR_BLACK)
green = curses.color_pair(3)
curses.init_pair(4,curses.COLOR_BLUE, curses.COLOR_BLACK)
blue = curses.color_pair(4)
curses.init_pair(5,curses.COLOR_YELLOW, curses.COLOR_BLACK)
yellow = curses.color_pair(5)
curses.init_pair(6,curses.COLOR_CYAN, curses.COLOR_BLACK)
cyan = curses.color_pair(6)
curses.init_pair(7,curses.COLOR_MAGENTA, curses.COLOR_BLACK)
magenta = curses.color_pair(7)

SERVERS=[
  {'srv': "srv1", 'color':red},
  {'srv': "srv2", 'color':green},
  {'srv': "srv3", 'color':yellow},
  {'srv': "srv3", 'color':blue},
  {'srv': "srv3", 'color':cyan},
  {'srv': "srv3", 'color':magenta},
  {'srv': "srv4", 'color': n},
]

MENU = "menu"
COMMAND = "command"
EXITMENU = "exitmenu"
COLOR = "color"

srv_list  = []
for srv in SERVERS:
  entry = { 'title': srv['srv'], 'type': COMMAND, 'command': "screen -t %s ssh %s" % (srv, srv), 'color':srv['color']}
  srv_list.append(entry)

menu_data = {
  'title': "SCREEN SSH", 'type': MENU, 'subtitle': "Select a server...",
  'options': srv_list
}

# This function displays the appropriate menu and returns the option selected
def runmenu(menu, parent):

  # work out what text to display as the last menu option
  if parent is None:
    lastoption = "Exit"
  else:
    lastoption = "Return to %s menu" % parent['title']

  optioncount = len(menu['options']) # how many options in this menu

  pos=0
  oldpos=None
  x = None

  # Loop until return key is pressed
  while x !=ord('\n'):
    if pos != oldpos:
      oldpos = pos
      screen.border(0)
      screen.addstr(2,2, menu['title'], curses.A_STANDOUT) # Title for this menu
      screen.addstr(4,2, menu['subtitle'], curses.A_BOLD) #Subtitle for this menu

      # Display all the menu items, showing the 'pos' item highlighted
      for index in range(optioncount):
        textstyle = menu['options'][index]['color']
        if pos==index:
          textstyle = textstyle | curses.A_REVERSE
        screen.addstr(5+index,4, "%d - %s" % (index+1, menu['options'][index]['title']), textstyle)
      # Now display Exit/Return at bottom of menu
      textstyle = n
      if pos==optioncount:
        textstyle = h
      screen.addstr(5+optioncount,4, "%d - %s" % (optioncount+1, lastoption), textstyle)
      screen.refresh()
      # finished updating screen

    x = screen.getch() # Gets user input

    # What is user input?
    if x >= ord('1') and x <= ord(str(optioncount+1)):
      pos = x - ord('0') - 1 # convert keypress back to a number, then subtract 1 to get index
    elif x == 258: # down arrow
      if pos < optioncount:
        pos += 1
      else: pos = 0
    elif x == 259: # up arrow
      if pos > 0:
        pos += -1
      else: pos = optioncount

  # return index of the selected item
  return pos

# This function calls showmenu and then acts on the selected item
def processmenu(menu, parent=None):
  optioncount = len(menu['options'])
  exitmenu = False
  while not exitmenu: #Loop until the user exits the menu
    getin = runmenu(menu, parent)
    if getin == optioncount:
        exitmenu = True
    elif menu['options'][getin]['type'] == COMMAND:
      curses.def_prog_mode()    # save curent curses environment
      os.system('reset')
      screen.clear() #clears previous screen
      os.system(menu['options'][getin]['command']) # run the command
      screen.clear() #clears previous screen on key press and updates display based on pos
      curses.reset_prog_mode()   # reset to 'current' curses environment
      curses.curs_set(1)         # reset doesn't do this right
      curses.curs_set(0)
    elif menu['options'][getin]['type'] == MENU:
          screen.clear() #clears previous screen on key press and updates display based on pos
          processmenu(menu['options'][getin], menu) # display the submenu
          screen.clear() #clears previous screen on key press and updates display based on pos
    elif menu['options'][getin]['type'] == EXITMENU:
          exitmenu = True

def clean_exit():
  curses.endwin() #VITAL! This closes out the menu system and returns you to the bash prompt.
  #os.system('clear')
  curses.nocbreak()
  screen.keypad(False)
  curses.echo()
  curses.endwin()

# Main programe
def main(screen):
  processmenu(menu_data)
  clean_exit()

if __name__ == '__main__':
  try:
    curses.wrapper(main)
  except KeyboardInterrupt:
    clean_exit()
    os.system('reset')
    sys.exit(1)
