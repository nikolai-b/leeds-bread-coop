require 'spec_helper'

describe Subscriber do
  subject { create :subscriber }
  its(:day_of_the_week) { should eq('Wednesday') }
end
