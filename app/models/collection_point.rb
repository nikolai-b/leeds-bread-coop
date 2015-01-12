class CollectionPoint < ActiveRecord::Base
  has_many :subscribers
  serialize :valid_days
  validate :valid_days_in_weekdays
  before_validation :normalize_valid_days

  scope :ordered, -> { order(:name) }

  def valid_day_names
    valid_days.map{ |vd| Date::DAYNAMES[vd][0..2] }.join(', ')
  end

  private

  def valid_days_in_weekdays
    errors.add(:valid_days, 'must be Wed or Fri') unless valid_days.reject(&:blank?).all? {|vd| vd == 5 || vd == 3 }
  end

  def normalize_valid_days
    self.valid_days = valid_days.reject(&:blank?).map &:to_i
  end
end
