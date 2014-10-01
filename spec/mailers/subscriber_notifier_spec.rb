require "spec_helper"

describe SubscriberNotifier do
  before do
    create :email_template, :with_real_template
    create :email_template, :with_real_template, name: 'sub_deleted'
  end
  let(:subscriber) { create :subscriber, :with_subscription }

  subject {SubscriberNotifier.new(subscriber)}

  it "sends a new_sub email to the subscriber" do
    subject.new_sub
    email = ActionMailer::Base.deliveries.last
    expect(email.body).to include("Welcome Lizzie!")
    expect(email.body).to include("Friday")
  end

  it "sends a sub_deleted email to the subscriber and info" do
    create :subscriber_item, subscriber: subscriber
    subject.sub_deleted
    email = ActionMailer::Base.deliveries.last
    expect(email.body).to include("White sour and White sour")
    expect(email.cc).to include("info@leedsbread.coop")
  end

end
