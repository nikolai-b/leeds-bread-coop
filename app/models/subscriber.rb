class Subscriber < ActiveRecord::Base
  require 'csv'
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable

  validates :collection_point, presence: true
  validates_format_of :email, :with => /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
  validates :first_name, length: {minimum: 3}
  validates :last_name, length: {minimum: 2}
  validates :phone, length: {in: 10..13}

  belongs_to :collection_point
  has_many :holidays, dependent: :destroy
  has_many :bread_types, through: :subscriptions
  has_many :subscriptions, dependent: :destroy
  has_one :stripe_account, dependent: :destroy

  before_destroy :cancel_stripe

  accepts_nested_attributes_for :subscriptions, allow_destroy: true

  scope :active_on, ->(date) { includes(:holidays, :subscriptions).where('holidays_count = 0 OR DATE(?) NOT BETWEEN holidays.start_date AND holidays.end_date', date).
                               where("subscriptions.paid" => :true).where('subscriptions.collection_day' => date.wday).references(:subscriptions, :holidays) }
  scope :ordered,          -> { order(:first_name, :last_name) }
  scope :pays_with_stripe, -> { includes(:stripe_account).references(:stripe_account).where(StripeAccount.arel_table[:customer_id].not_eq(nil)) }
  scope :pays_with_bacs,   -> { includes(:stripe_account).references(:stripe_account).where(StripeAccount.arel_table[:customer_id].eq(nil)) }
  scope :not_admin,        -> { where(admin: false) }

  def full_name
    "#{first_name} #{last_name}"
  end

  def num_unpaid_subs
    subscriptions.where(paid: false).count
  end

  def num_paid_subs
    subscriptions.where(paid: true).count
  end

  def collection_days
    subscriptions.map &:collection_day
  end

  def pays_with_stripe?
    stripe_account.try(:customer_id).present?
  end

  def self.import(file)
    transaction do
      CSV.foreach(file.path, headers: true) do |row|

        email = row["Email"].strip.downcase
        next if find_by( email: email)

        subscriber = new

        subscriber.collection_point = CollectionPoint.find_by( name: csv_collection_point[row["Drop-off"]] )
        subscriber.email = email
        subscriber.phone = row['Phone']
        subscriber.password = subscriber.email
        subscriber.address = row['Address']
        subscriber.first_name = row['Name'].split(' ')[0]
        last_name = row['Name'].split(' ')[1..-1].join(' ')

        if last_name.length < 3
          subscriber.last_name = 'No Last Name'
        else
          subscriber.last_name = row['Name'].split(' ')[1..-1].join(' ')
        end

        phone_length = subscriber.phone ? subscriber.phone.length : 0
        if phone_length > 13
          subscriber.phone = subscriber.phone.slice(0,13)
        elsif phone_length < 10
          subscriber.phone = " "*(10 - phone_length) + subscriber.phone.to_s
        end

        unless subscriber.valid?
          raise "Could not save #{subscriber.attributes}"
        end

        subscriber.subscriptions.build(
          bread_type_id: BreadType.find_by( name: csv_bread_type[row["Bread"]] ).id,
          collection_day: csv_collection_day[row['Days']],
          paid: true
        )

        unless subscriber.save
          raise "Could not save #{subscriber}"
        end
      end
    end
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << ['Name', 'Collection point', 'Email', 'Phone', '(S)tripe or (B)ACS']
      all.ordered.find_each do |subscriber|
        csv << [
          subscriber.full_name,
          subscriber.collection_point.name,
          subscriber.email,
          subscriber.phone,
          subscriber.pays_with_stripe? ? 'S' : 'B',
        ]
      end
    end
  end

  def mark_subscriptions_payment_as(paid)
    subscriptions.update_all paid: paid
  end

  def monthly_payment
    num_paid_subs * StripeAccount::MONTHLY_COST_PENCE / 100.0
  end

  private

  def cancel_stripe
    stripe_account.cancel if pays_with_stripe?
  end

  def self.csv_collection_point
    {
      "A" => "Wharf Chambers",
      "B" => "Greenhouse",
      "C" => "Lilac",
      "D" => "Fabrication",
      "E" => "Woodhouse Community Centre",
      "F" => "Haley & Clifford",
      "G" => "Opposite (Chapel Allerton)",
      "H" => "Cafe 164",
      "I" => "Green Action Food Co-op",
    }.freeze
  end

  def self.csv_bread_type
    {
      "WS" => "White Sourdough",
      "SS" => "Seedy Sourdough",
      "RY" => "Vollkornbrot (100% rye)",
      "SP" => "Weekly Special",
    }.freeze
  end

  def self.csv_collection_day
    {
      "Wed" => 3,
      "Fri" => 5,
    }.freeze
  end
end
