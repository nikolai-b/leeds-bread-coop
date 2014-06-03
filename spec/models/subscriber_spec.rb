require 'spec_helper'

describe Subscriber do
  subject { create :subscriber }
  its(:day_of_the_week) { should eq('Wednesday') }

  describe "import" do
    before do
      load 'db/seeds.rb'
    end

    it do
      Subscriber.import( File.read('data/subscriber_import.csv') )
    end
  end
end
