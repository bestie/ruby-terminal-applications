require "io/console"

tty = IO.console # /dev/tty

CSI = "\e["

def report_char_count(out, chars)
  out.write(move_home)
  out.write("You have typed #{chars.count} charaters")
end

def move_home
  CSI + "999" + "D"
end

chars = []

tty.raw do |io|
  loop do
    char = io.getch
    break if char == "\r"
    chars << char
    report_char_count(io, chars)
  end
end

STDOUT.puts chars.inspect
