require "spec_helper"

describe Notifier do
  before do
    create :new_sub_template
  end

  subject {Notifier}

  describe '#new_sub' do
    let!(:subscriber) { create :subscriber }
    before do
      create :subscriber_item, subscriber: subscriber
    end

    it "sends a templated email to the subscriber" do
      subject.new_sub(subscriber)
      email = ActionMailer::Base.deliveries.last
      expect(email.body).to include("Welcome Lizzie!")
      expect(email.body).to include("0113 0000000")
      expect(email.body).to include("White sour")
    end
  end
end
