class Subscriber < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable
  belongs_to :collection_point
  belongs_to :bread_type
  include Stripe::Callbacks
  scope :active_sub, -> { where(has_active_sub: true) }
  scope :delivery_day, ->(date) { where("TO_CHAR(start_date,'D') = ?", (date + 1.day).strftime("%w")) } # %w has Sun at 0, Postgres frm D has Sun as 1
  scope :has_sour_dough, -> {bread_type.where(sour_dough: true) }
  scope :has_yeast_dough, -> {bread_type.where.not(sour_dough: true) }



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
