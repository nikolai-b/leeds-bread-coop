class Subscriber < ActiveRecord::Base
  require 'csv'

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable

  class_attribute :payment_types

  PaymentType = Struct.new(:id, :name)

  self.payment_types = [
    PaymentType.new(1, 'Standing Order'),
    PaymentType.new(2, 'BACS'),
  ].index_by(&:id).freeze

  validates :collection_point, presence: true
  validates_format_of :email, :with => /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
  validates :first_name, length: {minimum: 3}
  validates :last_name, length: {minimum: 2}
  validates :phone, length: {in: 10..13}
  validates :payment_type_id, inclusion: { in: payment_types.keys, allow_blank: true }

  belongs_to :collection_point
  has_many :holidays, dependent: :destroy
  has_many :bread_types, through: :subscriptions
  has_many :subscriptions, inverse_of: :subscriber, dependent: :destroy
  has_one :stripe_account, dependent: :destroy

  before_destroy :cancel_stripe

  accepts_nested_attributes_for :subscriptions, allow_destroy: true

  scope :active_on, ->(date) { includes(:holidays, :subscriptions).where('holidays_count = 0 OR DATE(?) NOT BETWEEN holidays.start_date AND holidays.end_date', date).
                               where("subscriptions.paid_till >= ?", date).where('subscriptions.collection_day' => date.wday).references(:subscriptions, :holidays) }
  scope :ordered,             -> { order(:last_name, :first_name) }
  scope :pays_with_stripe,    -> { includes(:stripe_account).references(:stripe_account).where(StripeAccount.arel_table[:customer_id].not_eq(nil)) }
  scope :pays_without_stripe, -> { includes(:stripe_account).references(:stripe_account).where(StripeAccount.arel_table[:customer_id].eq(nil)) }
  scope :pays_with_bacs,      -> { pays_without_stripe.where(payment_type_id: 2) }
  scope :pays_with_so,        -> { pays_without_stripe.where(payment_type_id: 1) }
  scope :not_admin,           -> { where(admin: false) }
  scope :search,              -> (search)  { where("LOWER(CONCAT(first_name, ' ', last_name)) LIKE :s", s: "%#{search.downcase}%") }
  scope :paid_till_order,     -> { includes(:subscriptions).reorder("subscriptions.paid_till ASC").references(:subscriptions) }

  class << self
    def pays_with(type)
      if type.in? %w(stripe bacs so)
        send("pays_with_#{type}")
      else
        all
      end
    end
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def num_unpaid_subs
    subscriptions.where('paid_till < ? OR paid_till IS NULL', Date.today).count
  end

  def num_paid_subs
    subscriptions.where('paid_till >= ?', Date.today).count
  end

  def collection_days
    subscriptions.map(&:collection_day)
  end

  def pays_with_stripe?
    stripe_account.try(:customer_id).present?
  end

  def payment_type
    if stripe_account.try(:customer_id).present?
      PaymentType.new(3, 'Stripe')
    elsif payment_type_id
      payment_types[payment_type_id]
    else
      PaymentType.new(4, 'Unknown')
    end
  end

  class ImportError < StandardError
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
        subscriber.password = SecureRandom.hex 6
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
          raise ImportError, "Could not save #{subscriber.attributes} because #{subscriber.errors.full_messages.join(', ')}"
        end

        subscriber.subscriptions.build(
          bread_type_id: BreadType.find_by( name: csv_bread_type[row["Bread"]] ).id,
          collection_day: csv_collection_day[row['Days']],
          paid_till: 4.weeks.from_now
        )

        unless subscriber.save
          raise ImportError, "Could not save #{subscriber.attributes} because #{subscriber.errors.full_messages.join(', ')}"
        end
      end
    end
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << ['Name', 'Collection point', 'Email', 'Phone', 'Payment Type']
      all.ordered.find_each do |subscriber|
        csv << [
          subscriber.full_name,
          subscriber.collection_point.name,
          subscriber.email,
          subscriber.phone,
          subscriber.payment_type,
        ]
      end
    end
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
      "B" => "Cornerstone Housing Co-op",
      "C" => "Lilac",
      "D" => "Fabrication",
      "E" => "Woodhouse Community Centre",
      "F" => "Haley & Clifford",
      "G" => "Opposite (Chapel Allerton)",
      "H" => "Cafe 164",
      "I" => "Green Action Food Co-op",
      "J" => "Lidgett Lane Larder",
      "K" => "HEART Cafe",
    }.freeze
  end

  def self.csv_bread_type
    {
      "WS" => "White Sourdough",
      "SS" => "Seedy Sourdough",
      "RY" => "Vollkornbrot (100% rye)",
      "SP" => "Weekly Special",
      "MH" => "Malthouse Sourdough",
    }.freeze
  end

  def self.csv_collection_day
    {
      "Tue" => 2,
      "Thu" => 4,
    }.freeze
  end
end
