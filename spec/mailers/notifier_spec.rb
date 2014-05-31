require "spec_helper"

describe Notifier do
  before do
    create :new_sub_template
  end

  subject {Notifier}

  describe '#new_sub' do
    let!(:subscriber) { create :subscriber }

    it "sends a templated email to the subscriber" do
      subject.new_sub(subscriber)
      email = ActionMailer::Base.deliveries.last
      email.body = "Welcome Lizzie!\nLet us know if your details are incorrect, phone: 0113 ..., address: \nYou will be getting your bread Rye Sour Loaf from Green Action, LUU, LS2 .. on Wednesday starting on 2014-06-04\n"
    end
  end
end
