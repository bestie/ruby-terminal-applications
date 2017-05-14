# Simple filter script, like the worst grep ever
#
# Error or no matches found both result in no output
# Verbose debug output
search_term = ARGV.fetch(0) {
  STDERR.puts "No search term provided, quitting"
  exit(1) # Quits if there's nothing to saerch for
}

STDERR.puts "Looking for `#{search_term}`"
STDERR.puts ""
lines = 0
matches = 0

STDIN.readlines.each do |line|
  lines += 1
  if line.include?(search_term)
    matches += 1
    STDOUT.puts(line)
  end
end

STDERR.puts ""
STDERR.puts "Searched lines #{lines}"
STDERR.puts "Matches        #{matches}"
