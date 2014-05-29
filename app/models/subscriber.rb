class Subscriber < ActiveRecord::Base
  belongs_to :collection_point
  belongs_to :bread_type
end
