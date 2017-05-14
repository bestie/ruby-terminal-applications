class InteractiveTTYApp
  CSI = "\e["
  CTRL_C = ?\C-c
  CTRL_Z = ?\C-z

  def initialize(tty, &run_loop)
    @tty = tty
    @run_loop = run_loop
    @on_key = ->(*_) { } # Do nothing by default
  end

  def start
    @stopped = false
    trap_signals
    start_input_thread # Start a thread to collect input

    @tty.raw do |io|
      io.write(hide_cursor)
      until @stopped
        @run_loop.call(self)
      end
      STDOUT.puts "shutdown 1"
      io.write(show_cursor)
    end

      STDOUT.puts "shutdown 2"
    stop_input_thread # Thread could be waiting so explicitly terminate
      STDOUT.puts "shutdown 3"
  end

  def stop
    @stopped = true
  end

  def write(string)
    @tty.write(string)
  end

  def getch
    char = @tty.getch
    case char
      when CTRL_C
        send_signal("INT")
      when CTRL_Z
        send_signal("TSTP") # Terminal stop (suspend)
    end
    char
  end

  # Save the function to call when a key is pressed
  def on_key(&block)
    @on_key = block
  end

  def send_signal(signal)
    Process.kill(signal, Process.pid)
  end

  private

  # Loops until stopped, waits for a key then calls the block
  def start_input_thread
    @input_thread ||= Thread.new do
      until @stopped
        char = getch
        @on_key.call(char)
      end
    end
  end

  def stop_input_thread
    @input_thread.terminate
  end

  def trap_signals
    Signal.trap("INT") { stop }
    Signal.trap("TERM") { stop }
  end

  def hide_cursor
    CSI + "?25l"
  end

  def show_cursor
    CSI + "?25h"
  end
end

