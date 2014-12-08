class StripeSub
  extend ActiveModel::Naming
  attr_reader :errors


  def initialize(subscriber, notifier = nil)
    @subscriber = subscriber
    @notifier = notifier || SubscriberNotifier.new(subscriber)
    @errors = ActiveModel::Errors.new(self)
  end



end
