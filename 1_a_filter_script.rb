# Simple filter script, like the worst grep ever
#
# Error or no matches found both result in no output
search_term = ARGV.fetch(0) {
  exit(1) # Quits if there's nothing to saerch for
}

STDIN.readlines.each do |line|
  if line.include?(search_term)
    STDOUT.puts(line)
  end
end
