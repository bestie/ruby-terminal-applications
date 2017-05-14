require "securerandom"

TIME_FACTOR = 1.0

class Refund
  def self.get_first_unprocessed
    sleep(1 * TIME_FACTOR)

    new(
      transaction_id: SecureRandom.uuid,
      processed: false,
    )
  end

  def initialize(transaction_id:, processed:)
    @transaction_id = transaction_id
    @processed = processed
  end

  attr_reader :transaction_id

  def processed?
    @processed
  end

  def mark_as_processed
    sleep(1 * TIME_FACTOR)
    @processed = true
    self
  end
end

class PaymentGatewayAdapter
  def refund(_transaction_id)
    sleep(2 * TIME_FACTOR)
    true
  end
end

PAYMENT_GATEWAY = PaymentGatewayAdapter.new
