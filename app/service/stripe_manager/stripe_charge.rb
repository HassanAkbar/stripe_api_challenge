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
      { success: false, error: e.message }
    rescue Stripe::APIConnectionError
      { success: false, error: e.message }
    rescue Stripe::StripeError => e
      { success: false, error: e.message }
    rescue StandardError => e
      { success: false, error: e.message }
    end
  end
end
