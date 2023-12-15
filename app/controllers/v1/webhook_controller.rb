# frozen_string_literal: true

module V1
  # class to process stripe webhook
  class WebhookController < ApplicationController
    def create # rubocop:disable Metrics/MethodLength
      webhook_secret = ENV['STRIPE_WEBHOOK_SECRET']
      sig_header = request.env['HTTP_STRIPE_SIGNATURE']
      payload = request.body.read
      event = Stripe::Webhook.construct_event(payload, sig_header, webhook_secret)
      handle_event(event)
      render status: 200, json: { message: 'OK' }
    rescue JSON::ParserError => e
      puts "⚠️  JSON Parse failed : #{e}"
      render_error(400, e)
    rescue Stripe::SignatureVerificationError => e
      puts "⚠️  Webhook signature verification failed : #{e}"
      render_error(400, e)
    end

    private

    def handle_event(event)
      case event.type
      when 'charge.succeeded'
        charge = event.data.object
        puts "charge event: #{charge.status}"
      when 'charge.refunded'
        refund = event.data.object
        puts "refund event: #{refund.status}"
      else
        puts "Unhandled event type: #{event.type}"
      end
    end

    def render_error(status_code, error_message)
      render status: status_code, json: { message: error_message }
    end
  end
end
