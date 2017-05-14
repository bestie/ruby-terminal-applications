# Creating Terminal Applications in Ruby (code samples)

1 a) Simple filter script. Reads from STDIN, outputs matching lines to STDOUT.
     `$ cat /usr/share/dict/words | ruby 1_a_filter_script.rb rubby`
     Output all dictionary entries containing 'rubby'

  b) Verbose filter script. As above but uses STDERR to output information that
     is not contained in the 'real' output. This can be demonstrated by
     outputting to a file.
     `$ cat /usr/share/dict/words | ruby 1_b_filter_script.rb rubby > rubby.txt`
     Now check the contents of `rubby.txt` which will be missing the extra info.

  c) Daemon to process refunds. Amoung other problems can be interrupted with
     SIGINT (ctrl-c) inbetween refunding the customer and marking the refun as
     complete, potentially resulting in a duplicate refund.

  d) Improved daemon using a abstracted runner which traps SIGINT and SIGTERM
     ensuring that the transaction fully completes before exit.

2 a) Demonstrates reading keyboard input from STDIN. STDIN is however line
     buffered, requiring the user to press enter before the program receives
     any input.

  b) We use the /dev/tty device to directly access the keyboard. We receive
     keystrokes immediately but using raw mode to directly control the terminal
     has strange consequences. Where have the carriage returns gone?

  c) A cooler TTY based app. Output is a single line which is re-written with
     each keystroke. We overwrite the top line by first not printing a carriage
     return then moving the cursor back home using a terminal control sequence
     to move 999 characters back. Writing more output from there overwrites
     previously printed characters.

  d) More control codes. This time we hide the cursor to make the 'UI' look
     cleaner. It is extremely important to print the show cursor `?25h` code
     before exit otherwise this app leaves the user without a cursor.

  e) TTY and signals. Now the program receives all keystrokes unfiltered,
     direct from the TTY device our app no longer responds to `ctrl-`z or
     `ctrl-c` in the way we expect. The `TTYApp` provides some help to the TTY
     looking for those key combos, sending and trapping signals as appropriate.
     Here SIGINT is both sent and received in order to play nicely with other
     code that may be looking to trap that signal. This avoids our code bieng
     a special case.

  f) Fully interactive TTY app. This app demonstrates how we can decouple
     rendering from keystrokes by monitoring input in another thread. A main
     loop running at approx 60fps draw a new UI (re-prints a single line).
     The message and spinner change at differing frequencies and rather than
     keystrokes registering immediately they are taken into account when
     drawing the next frame.
