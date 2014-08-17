require "spec_helper"

describe SubscriberNotifier do
  before do
    create :email_template, :with_real_template
    create :email_template, :with_real_template, name: 'sub_deleted'
  end
  let(:subscriber) { create :subscriber, :subscription }

  subject {SubscriberNotifier.new(subscriber)}

  it "sends a new_sub email to the subscriber" do
    subject.new_sub
    email = ActionMailer::Base.deliveries.last
    expect(email.body).to include("Welcome Lizzie!")
  end

  it "sends a sub_deleted email to the subscriber" do
    create :subscriber_item, subscriber: subscriber
    subject.sub_deleted
    email = ActionMailer::Base.deliveries.last
    expect(email.body).to include("White sour and White sour")
  end

end
