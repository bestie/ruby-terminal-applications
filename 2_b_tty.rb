require "io/console"

tty = IO.console # /dev/tty

chars = []

tty.raw do |io|
  while chars.length < 10
    char = io.getch
    chars << char
    io.puts "Got #{chars.length} characters"
  end
end

# STDOUT is back to normal here outside of the raw block
STDOUT.puts chars.inspect
