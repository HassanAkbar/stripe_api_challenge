# frozen_string_literal: true

require 'rails_helper'
require 'support/fixtures'

module StripeManager
  class StripeRefund < ApplicationService
    describe '#call' do # rubocop:disable Metrics/BlockLength
      let(:params) { Fixtures.json('refund_success') }

      context '[positive price]' do
        subject(:api_response) { StripeManager::StripeRefund.call('ch_3ONCyRDveNh8GNXD2acUy0c3') }

        it 'it refunds charge' do
          allow(Stripe::Refund).to receive(:create).with({ charge: 'ch_3ONCyRDveNh8GNXD2acUy0c3' }).and_return(:params)
          api_response
          expect(Stripe::Refund).to(
            have_received(:create)
          )
        end
      end

      context '[already refunded]' do
        subject(:api_response) { StripeManager::StripeRefund.call('ch_3ONCyRDveNh8GNXD2acUy0c3') }

        it 'give error if charge is already refunded' do
          allow(Stripe::Refund).to receive(:create).with({ charge: 'ch_3ONCyRDveNh8GNXD2acUy0c3' }).and_return({
                                                                                                                 success: false, error: 'Refund ch_3ONCyRDveNh8GNXD2acUy0c3 has already been refunded.'
                                                                                                               })
          api_response
          expect(Stripe::Refund).to(
            have_received(:create)
          )
        end
      end

      context '[already refunded]' do
        subject(:api_response) { StripeManager::StripeRefund.call('ch_3ONCyRDveNh8GNXD2acUy0c') }

        it 'it gives error if charge id is invalid' do
          allow(Stripe::Refund).to receive(:create).with({ charge: 'ch_3ONCyRDveNh8GNXD2acUy0c' }).and_return({
                                                                                                                success: false, error: "No such charge: 'ch_3ONCyRDveNh8GNXD2acUy0c'"
                                                                                                              })
          api_response
          expect(Stripe::Refund).to(
            have_received(:create)
          )
        end
      end

      context '[already refunded]' do
        subject(:api_response) { StripeManager::StripeRefund.call('') }

        it 'it gives error if no charge id is present' do
          allow(Stripe::Refund).to receive(:create).and_return({ success: false,
                                                                 error: 'One of the following params should be provided for this request: payment_intent or Refund.' })
          api_response
          expect(Stripe::Refund).to(
            have_received(:create)
          )
        end
      end
    end
  end
end
