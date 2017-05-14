require "io/console"

class TTYApp
  CSI = "\e["
  CTRL_C = ?\C-c
  CTRL_Z = ?\C-z

  def initialize(tty, &run_loop)
    @tty = tty
    @run_loop = run_loop
  end

  def start
    @stopped = false
    trap_signals

    @tty.raw do |io|
      io.write(hide_cursor)
      until @stopped
        @run_loop.call(self)
      end
      io.write(show_cursor)
    end
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

  def send_signal(signal)
    Process.kill(signal, Process.pid)
  end

  private

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

chars = []

app = TTYApp.new(IO.console) do |app|
  char = app.getch
  app.stop if char == "\r"
  chars << char
  app.write("\rYou have typed #{chars.count} charaters")
end

app.start

STDOUT.puts "\n" + chars.inspect
