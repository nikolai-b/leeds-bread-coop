class Subscriber < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable
  belongs_to :collection_point
  belongs_to :bread_type

  def day_of_the_week
    start_date.strftime('%A')
  end
end
