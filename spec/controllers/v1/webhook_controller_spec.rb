# frozen_string_literal: true

require 'rails_helper'
require 'support/fixtures'
RSpec.describe V1::WebhookController, type: :request do # rubocop:disable Metrics/BlockLength
  let(:body) { Fixtures.json('stripe_webhook') }
  let(:charge_event) { JSON.parse(Fixtures.fixture_content('stripe_charge_event'), object_class: OpenStruct) }
  let(:refund_event) {  JSON.parse(Fixtures.fixture_content('stripe_refund_event'), object_class: OpenStruct) }
  let(:unhandled_event) { JSON.parse(Fixtures.fixture_content('charge_updated'), object_class: OpenStruct) }

  webhook = V1::WebhookController.new

  context '[success case]' do
    describe 'webhook event' do
      it 'will return a 200 if successful' do
        @request_body = body
        bypass_event_signature(@request_body.to_json)
        post(v1_webhook_path, params: @request_body)
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe '#handle_event' do
    context '[charge case]' do
      it 'it will process charge event' do
        expect do
          webhook.send(:handle_event, charge_event)
        end.to output("charge event: #{charge_event.data.object.status}\n").to_stdout
      end
    end
  end

  describe '#handle_event' do
    context '[refund case]' do
      it 'it will process refund event' do
        expect do
          webhook.send(:handle_event, refund_event)
        end.to output("refund event: #{refund_event.data.object.status}\n").to_stdout
      end
    end
  end

  describe '#handle_event' do
    context '[unhandled case]' do
      it 'it will process unhandled event' do
        expect do
          webhook.send(:handle_event, unhandled_event)
        end.to output("Unhandled event type: #{unhandled_event.type}\n").to_stdout
      end
    end
  end

  def bypass_event_signature(payload)
    @event = Stripe::Event.construct_from(JSON.parse(payload, symbolize_names: true))
    expect(Stripe::Webhook).to receive(:construct_event).and_return(@event)
  end
end
