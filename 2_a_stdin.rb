chars = []

while chars.length < 10
  char = STDIN.getc
  chars << char
  STDOUT.puts "Got #{chars.length} characters"
end

STDOUT.puts chars
