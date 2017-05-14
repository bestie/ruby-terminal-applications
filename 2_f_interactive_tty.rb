require "io/console"
require_relative "interactive_tty_app"

chars = []

messages = [
  "You might not think this is useful ",
  "but I think it nicely demostrates  ",
  "use of the TTY device to build     ",
  "interative applications            ",
]

spinner = "│ / ─ \\".split(" ")

frame_count = 0
frame_pause = 1/60.0 # ~60 Frames/sec
message_period = 120 # frames
spinner_period = 3 # frames

app = InteractiveTTYApp.new(IO.console) do |app|
  message_index = (frame_count / message_period) % messages.length
  spinner_index = (frame_count / spinner_period) % spinner.length

  app.write(
    "\r" +
    messages[message_index] +
    " char count = #{chars.count} " +
    spinner[spinner_index]
  )

  frame_count += 1
  sleep(frame_pause)
end

app.on_key do |char|
  if char == "\r"
    app.stop
  else
    chars << char
  end
end

app.start

STDOUT.puts "\n" + chars.inspect
