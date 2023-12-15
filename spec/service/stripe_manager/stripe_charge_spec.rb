# frozen_string_literal: true

require 'rails_helper'
require 'support/fixtures'

module StripeManager
  class StripeCharge < ApplicationService
    describe '#call' do # rubocop:disable Metrics/BlockLength
      let(:params) { Fixtures.json('refund_success') }

      context '[positive price]' do
        subject(:api_response) { StripeManager::StripeCharge.call(1099, 'usd', 'tok_visa') }

        it 'it creates new charge' do
          allow(Stripe::Charge).to receive(:create).with({ amount: 1099, currency: 'usd',
                                                           source: 'tok_visa' }).and_return(:params)
          api_response
          expect(Stripe::Charge).to(
            have_received(:create)
          )
        end
      end

      context '[negative price]' do
        subject(:api_response) { StripeManager::StripeCharge.call(-1099, 'usd', 'tok_visa') }

        it 'it does not create charge for invalid price' do
          allow(Stripe::Charge).to receive(:create).with({ amount: -1099,
                                                           currency: 'usd', source: 'tok_visa' }).and_return({ success: false,
                                                                                                               error: 'This value must be greater than or equal to 1.' })
          api_response
          expect(Stripe::Charge).to(
            have_received(:create)
          )
        end
      end

      context '[zero price]' do
        subject(:api_response) { StripeManager::StripeCharge.call(0, 'usd', 'tok_visa') }

        it 'does not create charge for 0 price' do
          allow(Stripe::Charge).to receive(:create).with({ amount: 0, currency: 'usd',
                                                           source: 'tok_visa' }).and_return({ success: false,
                                                                                              error: 'This value must be greater than or equal to 1.' })
          api_response
          expect(Stripe::Charge).to(
            have_received(:create)
          )
        end
      end

      context '[usd currency]' do
        subject(:api_response) { StripeManager::StripeCharge.call(10.99, 'usd', 'tok_visa') }

        it 'gives Error on non integer ammount' do
          allow(Stripe::Charge).to receive(:create).with({ amount: 10.99, currency: 'usd',
                                                           source: 'tok_visa' }).and_return({ "success": 'false',
                                                                                              "error": 'Invalid integer: 0.5' })
          api_response
          expect(Stripe::Charge).to(
            have_received(:create)
          )
        end
      end

      context '[other supported currency]' do
        subject(:api_response) { StripeManager::StripeCharge.call(10, 'sar', 'tok_visa') }

        it 'gives error for less that 50 cents ammount' do
          allow(Stripe::Charge).to receive(:create).with({ amount: 10, currency: 'sar',
                                                           source: 'tok_visa' }).and_return({ success: false,
                                                                                              error: 'Amount must convert to at least 50 cents. ر.س0.10 converts to approximately $0.03.' })
          api_response
          expect(Stripe::Charge).to(
            have_received(:create)
          )
        end
      end

      context '[non supported currency]' do
        subject(:api_response) { StripeManager::StripeCharge.call(10_000, 'yen', 'tok_visa') }

        it 'gives error for unsupported currency' do
          allow(Stripe::Charge).to receive(:create).with({ amount: 10_000, currency: 'yen',
                                                           source: 'tok_visa' }).and_return({ success: false,
                                                                                              error: 'Invalid currency: yen. Stripe currently supports these currencies: usd, aed, afn, all, amd, ang, aoa, ars, aud, awg, azn, bam, bbd, bdt, bgn, bhd, bif, bmd, bnd, bob, brl, bsd, bwp, byn, bzd, cad, cdf, chf, clp, cny, cop, crc, cve, czk, djf, dkk, dop, dzd, egp, etb, eur, fjd, fkp, gbp, gel, gip, gmd, gnf, gtq, gyd, hkd, hnl, hrk, htg, huf, idr, ils, inr, isk, jmd, jod, jpy, kes, kgs, khr, kmf, krw, kwd, kyd, kzt, lak, lbp, lkr, lrd, lsl, mad, mdl, mga, mkd, mmk, mnt, mop, mur, mvr, mwk, mxn, myr, mzn, nad, ngn, nio, nok, npr, nzd, omr, pab, pen, pgk, php, pkr, pln, pyg, qar, ron, rsd, rub, rwf, sar, sbd, scr, sek, sgd, shp, sle, sos, srd, std, szl, thb, tjs, tnd, top, try, ttd, twd, tzs, uah, ugx, uyu, uzs, vnd, vuv, wst, xaf, xcd, xof, xpf, yer, zar, zmw, usdc, btn, ghs, eek, lvl, svc, vef, ltl, sll, mro' })
          api_response
          expect(Stripe::Charge).to(
            have_received(:create)
          )
        end
      end
    end
  end
end
