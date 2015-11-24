class CollectionPoint < ActiveRecord::Base
  has_many :subscribers
  serialize :valid_days
  validate :valid_days_in_weekdays
  before_validation :normalize_valid_days

  scope :ordered, -> { order(:name) }

  ValidDay = Struct.new(:id) do
    def name
      Date::DAYNAMES[id]
    end
  end
  class_attribute :all_valid_days
  self.all_valid_days = [
    ValidDay.new(2),
    ValidDay.new(4),
  ].index_by(&:id).freeze

  def valid_day_names
    valid_days.map{ |vd| Date::DAYNAMES[vd][0..2] }.join(', ')
  end

  private

  def valid_days_in_weekdays
    unless valid_days.reject(&:blank?).all? {|vd| vd.in? all_valid_days.keys }
      errors.add(:valid_days,
                 "must be #{all_valid_days.values.map(&:name).to_sentence(last_word_connector: 'or')}")
    end
  end

  def normalize_valid_days
    self.valid_days = valid_days.reject(&:blank?).map(&:to_i)
  end
end
