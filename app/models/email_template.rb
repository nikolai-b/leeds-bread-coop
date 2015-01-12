class EmailTemplate < ActiveRecord::Base
  scope :ordered, -> { order(:name) }
end
