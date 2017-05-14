class Runner
  def initialize(out, &task)
    @out = out
    @stopped = false
    @task = task
  end

  def start
    trap_signals
    work_until_stopped
    @out.puts "Cleanly shutdown"
  end

  def stop
    @out.puts "Shutting down gracefully"
    @stopped = true
  end

  private

  def work_until_stopped
    while !@stopped
      @task.call
      sleep(1)
    end
  end

  def trap_signals
    Signal.trap("SIGINT") { stop }
    Signal.trap("SIGTERM") { stop }
  end
end
