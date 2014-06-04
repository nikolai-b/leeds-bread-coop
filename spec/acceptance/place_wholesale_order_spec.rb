require 'spec_helper'

feature "New user, new sign-up", type: :feature,  js: false  do
  before :each do
    create :bread_type
    create :wholesale_customer
    create :subscriber, :admin
  end

  scenario "Place a customer order" do
    sign_in_as_admin

    click_on "Orders"

    click_on "New Order"

    fill_in_order_details

  end

  def sign_in_as_admin
    visit "/"

    fill_in "Email", with: "admin@example.com"
    fill_in "Password", with: "password"

    click_on "Sign in"
  end
end
