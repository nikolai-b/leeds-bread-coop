require 'spec_helper'

describe StripeApi::Invoice do
  it 'has a sensible total' do
    subject = described_class.new(double('StripeInvoice', total: 220))
    expect(subject.total).to eq('2.20')
  end
end
