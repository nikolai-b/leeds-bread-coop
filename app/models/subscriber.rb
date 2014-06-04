class Subscriber < ActiveRecord::Base
  require 'csv'
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable

  validates :bread_type_id, numericality: { only_integer: true }
  validates :collection_point_id, numericality: { only_integer: true }
  validates_format_of :email, :with => /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
  validates :name, length: {minimum: 4}
  validates :phone, length: {in: 10..13}

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
    CSV.foreach(file.path, headers: true) do |row|

      row['Email'].gsub!(/(.*)@(.*)/,'\1@example.com')
      row['Email'].downcase!

      next if find_by( email: row["Email"].strip)

      subscriber = new

      subscriber.collection_point = CollectionPoint.find_by( name: csv_collection_point[row["Drop-off"]] )
      subscriber.bread_type = BreadType.find_by( name: csv_bread_type[row["Bread"]] )
      subscriber.start_date = csv_start_date[row['Days']]
      subscriber.email = row['Email']
      subscriber.phone = '0777 777777' #row['Phone']
      subscriber.password = subscriber.email
      subscriber.active_sub = true
      subscriber.address = 'Leeds' #row['Address']
      subscriber.name = row['Name']

      subscriber.save
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
      "Fri" => Date.parse('2014-06-06'),
    }
  end

end
