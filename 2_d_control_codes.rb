require "io/console"

tty = IO.console # /dev/tty

CSI = "\e["

def hide_cursor
  CSI + "?25l"
end

def show_cursor
  CSI + "?25h"
end

def move_home
  CSI + "999" + "D"
end

def report_char_count(out, chars)
  out.write(move_home)
  out.write("You have typed #{chars.count} charaters")
end

chars = []

tty.raw do |io|
  io.write(hide_cursor)
  loop do
    char = io.getch
    break if char == "\r"
    chars << char
    report_char_count(io, chars)
  end
  io.write(show_cursor)
  io.write("\r\n")
end

STDOUT.puts chars.inspect
