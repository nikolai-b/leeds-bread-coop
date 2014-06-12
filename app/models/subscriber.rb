class Subscriber < ActiveRecord::Base
  require 'csv'
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable

  validates :collection_point_id, numericality: { only_integer: true }
  validates_format_of :email, :with => /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
  validates :name, length: {minimum: 4}
  validates :phone, length: {in: 10..13}

  belongs_to :collection_point

  has_many :subscriber_items

  accepts_nested_attributes_for :subscriber_items, allow_destroy: true
  has_many :bread_types, through: :subscriber_items


  def num_paid_subs
    subscriber_items.where(paid: true).count
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|

      email = row["Email"].strip.downcase
      next if find_by( email: email)

      subscriber = new

      subscriber.collection_point = CollectionPoint.find_by( name: csv_collection_point[row["Drop-off"]] )
      subscriber.email = email
      subscriber.phone = row['Phone']
      subscriber.password = subscriber.email
      subscriber.address = row['Address']
      subscriber.name = row['Name']
      subscriber.save

      subscriber.subscriber_items.create(
        bread_type_id: BreadType.find_by( name: csv_bread_type[row["Bread"]] ).id,
        collection_day: csv_collection_day[row['Days']],
        paid: true
      )

    end
  end

  def mark_subscriber_items_payment_as(paid)
    subscriber_items.each do |sub_item|
      sub_item.update({paid: paid})
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

  def self.csv_collection_day
    {
      "Wed" => 3,
      "Fri" => 5,
    }
  end

end
