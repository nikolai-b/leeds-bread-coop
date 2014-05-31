class Subscriber < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable
  belongs_to :collection_point
  belongs_to :bread_type
  include Stripe::Callbacks

  after_customer_subscription_deleted! do |subscription, event|
    stripe_customer_id = subscription.customer

    subscriber = Subscriber.find_by_stripe_customer_id stripe_customer_id

    subscriber.has_active_sub = false
    subscriber.save!

    Notifier.sub_deleted(subscriber)
  end



  def day_of_the_week
    start_date.strftime('%A')
  end
end
