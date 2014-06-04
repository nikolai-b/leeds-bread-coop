require 'spec_helper'

feature "New user, new sign-up", type: :feature,  js: true  do
  before :each do
    Capybara.javascript_driver = :poltergeist
    Capybara.current_driver = :poltergeist
    create :wholesale_customer
    create :subscriber, :admin
  end

  scenario "Place a customer order" do
    sign_in_as_admin

    click_on "Wholesale"

    click_on "New Order"

    expect(page).to have_content "Lanes"

    fill_in_order_details

    expect(page).to have_content "Order was successfully created."

    expect(page).to have_content "White sour: 12"
  end

  def sign_in_as_admin
    visit "/"

    fill_in "Email", with: "admin@example.com"
    fill_in "Password", with: "password"

    click_on "Sign in"
  end

  def fill_in_order_details
    fill_in "Date", with: (Date.current + 3.days).strftime

    page.find('.add').trigger('click')

    fill_in "Quantity", with: 12
    select "White sour"

    click_on 'Create Order'
  end
end
