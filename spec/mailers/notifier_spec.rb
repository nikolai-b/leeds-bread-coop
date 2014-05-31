require "spec_helper"

describe Notifier do
  before do
    create :email_template
  end

  subject {Notifier}

  describe '#new_sub' do
    let!(:subscriber) { create :subscriber }

    it "sends and email to the subscriber" do
      subject.new_sub(subscriber)
      email = ActionMailer::Base.deliveries.last
      email.body = 'Welcome!'
    end
  end
end
