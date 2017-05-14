require "io/console"

slides = DATA.read.split("\n\n").map { |lines| lines.split("\n") }
slide_index = 0

def print_slide(io, slide)
  height, width = io.winsize
  twitter_handle = "@the_bestie"
  padding = " " * 5

  io.write("\e[H\e[2J")

  io.puts "\r"
  io.puts "\r"
  slide.each do |line|
    io.puts padding + line + "\r"
    io.puts
  end
  io.puts "\r"
  io.puts " " * (width - twitter_handle.length - padding.length) + twitter_handle
  io.puts "\r"
end

IO.console.raw do |io|
  print_slide(io, slides[slide_index])

  loop do
    char = io.getch

    case char
    when "h"
      slide_index = [0, slide_index - 1].max
      print_slide(io, slides[slide_index])
    when "l"
      slide_index = [slides.length - 1, slide_index + 1].min
      print_slide(io, slides[slide_index])
    when "q"
      break
    end
  end
end

__END__
Creating terminal apps with Ruby
 
 
 for CPH Ruby Brigade by Stephen Best
 

 
  What is a terminal?
 
 
 

* Used to be a physical piece of hardware
* DEC VT-05 (1970)
* Very much a dumb terminal, mostly used to connect to mainframes
* Functionally equivalent to a printer and a keyboard
 

* Bill Joy had a ADM-3A when he created vi
* http://www.vintagecomputer.net/LSI/ADM3A/LSI_ADM3A_21818_keyboard.jpg
 
 
 

* What we now refer to as a terminal is a graphical emulator program that
    mimics these old machines
* Also now we often want to send commands to the same machine (on our lap)
* Other times we want to send commands to a shared machine in much the same way
    (SSH) where our terminal is connected to the remote machines shell.

* The shell is software that takes the command (after return) and runs programs
* Named the 'shell' because it wraps around the kernel
 
 
 

* The terminal deals with your typing
* The shell executes programs on the machine
 
 
 

* The terminal can operate in different modes
* - Line buffered
* - Raw
* - No echo
 

* A terminal emulator can be used without a shell (telnet, irb)
* The shell can be used without a terminal (shell scripting)
 
 
 

 
   Now let's see some code!
     - What are terminals capable of?
     - How can we make them do 'cool stuff'?
 
