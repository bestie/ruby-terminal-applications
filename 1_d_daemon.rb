require_relative "things_the_audience_should_not_worry_about"
require_relative "runner"

runner = Runner.new(STDERR) do
  refund = Refund.get_first_unprocessed
  STDOUT.puts "Started processing refund #{refund.transaction_id}"

  PAYMENT_GATEWAY.refund(refund.transaction_id)
  STDOUT.puts "Funds returned to customer"

  refund.mark_as_processed
  STDOUT.puts "Processing complete #{refund.transaction_id}"
end

runner.start
