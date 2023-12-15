# frozen_string_literal: true

module StripeManager
  # stripe charge service
  class StripeRefund < ApplicationService
    def initialize(charge_id)
      @charge_id = charge_id
    end

    def call
      refund = Stripe::Refund.create({ charge: @charge_id })
      { success: true, refund: }
    rescue Stripe::InvalidRequestError => e
      # Handle invalid request (e:g wrong charge_id or already refunded charge_id etc).
      { success: false, error: e.message }
    rescue Stripe::APIConnectionError
      # Handle errors related to Stripe downtime or other connection problems.
      { success: false, error: e.message }
    rescue Stripe::StripeError => e
      # Handle other stripe-specific errors.
      { success: false, error: e.message }
    rescue StandardError => e
      # Handle other errors that may occur during the process.
      { success: false, error: e.message }
    end
  end
end
