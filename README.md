# Readme

## Introduction

This Rails API application is designed to handle payment processing using the Stripe API. It provides endpoints for creating and managing payments, as well as handling webhooks for events such as successful payments or chargebacks.

## Getting Started

### Prerequisites

* Ruby (version 3.2.2)
* Rails (version 7.0.8)
* Stripe account (sign up at Stripe)

### Installation

Clone the repository:
```bash
git clone git@github.com:HassanAkbar/stripe_api_challenge.git
```

Install dependencies:
```bash
cd stripe_api_challenge
bundle install
```

## Configuration

### Stripe Setup
Create a Stripe account if you don't have one.
Obtain your API keys from the Stripe Dashboard: `Dashboard > Developers > API keys`.
Set your API keys in the Environment Variables

```bash
export STRIPE_WEBHOOK_SECRET=your-webhook-secret-key
export STRIPE_API_KEY=your-stripe-api-key
```

### Testing

To run tests, use:

```bash
bundle exec rspec
```
