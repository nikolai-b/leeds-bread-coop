require 'spec_helper'

feature "Place wholesale order", type: :feature,  js: true  do
  before :each do
    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, js_errors: false)
    end
    Capybara.javascript_driver = :poltergeist
    Capybara.current_driver = :poltergeist
    create :wholesale_customer
    create :subscriber, :admin
    create :bread_type
    create :email_template
  end

  scenario "Place a customer order" do
    sign_in_as_admin

    click_on "Wholesale"

    click_on "New Order"

    expect(page).to have_content "Lanes"

    fill_in_order_details

    expect(page).to have_content "Order was successfully created."

    expect(page).to have_content "White Sourdough: 12"
  end

  def sign_in_as_admin
    visit "/"

    fill_in "Email", with: "admin@example.com"
    fill_in "Password", with: "password"

    click_on "Sign in"
  end

  def fill_in_order_details
    fill_in "Date", with: "25/11/25"

    page.find('.add').trigger('click')

    fill_in "Quantity", with: 12
    select "White Sourdough"

    click_on 'Create'
  end
end
