# frozen_string_literal: true

module StripeManager
  # stripe charge service
  class StripeCharge < ApplicationService
    def initialize(price, currency, source)
      @currency = currency
      @price = price
      @source = source
    end

    def call
      charge = Stripe::Charge.create({ amount: @price, currency: @currency, source: @source })
      { success: true, charge: }
    rescue Stripe::InvalidRequestError => e
      # Handle invalid request (e:g wrong ammount,invalid ammount, unsupported currency, invalid source, etc).
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
