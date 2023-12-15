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
