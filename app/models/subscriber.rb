class Subscriber < ActiveRecord::Base
  require 'csv'
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable
  belongs_to :collection_point
  belongs_to :bread_type

  scope :active_sub, -> { where(active_sub: true) }
  scope :delivery_day, ->(date) { where("TO_CHAR(start_date,'D') = ?", (date + 1.day).strftime("%w")) } # %w has Sun at 0, Postgres frm D has Sun as 1
  scope :has_sour_dough, -> {bread_type.where(sour_dough: true) }
  scope :has_yeast_dough, -> {bread_type.where.not(sour_dough: true) }

  include Stripe::Callbacks



  after_customer_subscription_deleted! do |subscription, event|
    stripe_customer_id = subscription.customer

    subscriber = Subscriber.find_by_stripe_customer_id stripe_customer_id

    subscriber.active_sub = false
    subscriber.save!

    Notifier.sub_deleted(subscriber)
  end



  def day_of_the_week
    start_date.strftime('%A')
  end

  def self.import(file)
    csv = CSV.parse(file, headers: true)
    csv.each do |row|
      row['collection_point_id'] = CollectionPoint.find_by( name: csv_collection_point[row["collection_point_id"]] ).id
      row['bread_type_id'] = BreadType.find_by( name: csv_bread_type[row["bread_type_id"]] ).id
      row['start_date'] = csv_start_date[row['start_date']]

      subscriber = find_by( email: row["email"]) || new
      subscriber.attributes = row.to_hash
      subscriber.password = row['email']

      subscriber.save!
    end
  end

  private

  def self.csv_collection_point
    {
      "A" => "Wharf Chambers",
      "B" => "Greenhouse",
      "C" => "LILAC",
      "D" => "Fabrication",
      "E" => "Woodhouse",
      "F" => "Haley&Cliff",
      "G" => "Opposite",
      "H" => "Cafe 164",
      "I" => "Green Action",
    }
  end

  def self.csv_bread_type
    {
      "WS" => "White Sour",
      "SS" => "Seedy Sour",
      "RY" => "100% Rye",
      "SP" => "Special",
    }
  end

  def self.csv_start_date
    {
      "Wed" => Date.parse('2014-06-04'),
      "Fri" => Date.parse('2014-06-04'),
    }
  end

end
