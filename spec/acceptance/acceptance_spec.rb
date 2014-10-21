require 'spec_helper'
require 'thin'

feature "New user, new sign-up", type: :feature,  js: true  do

  before :each do
    create :collection_point
    create :bread_type
    create :email_template, :with_real_template
    Capybara.current_driver = :selenium
    Capybara.javascript_driver = :selenium
  end

  scenario "New subscription" do
    visit '/'

    click_on 'Sign up'

    see_new_user_details

    fill_in_details

    expect(page).to have_content "You have signed up successfully."

    pay_stripe

    see_success

    get_email
  end

  def see_new_user_details
    expect(page).to have_content "First name"
    expect(page).to have_content "Phone"
    expect(page).to have_content "Bread type"
  end

  def fill_in_details
    fill_in 'First name', with: 'Lizzie'
    fill_in 'Last name',  with: 'Surname'
    fill_in "Email",      with: 'lizzie@example.com'
    fill_in "Address",    with: 'Somewhere in Leeds'
    fill_in "Phone",      with: '01132222222'
    select 'Green Action', from: :subscriber_collection_point_id
    select "Wednesday", from: "Collection day"
    select 'White sour'
    fill_in "Password",   with: 'password'
    fill_in "Notes",      with: 'Thanks!'

    click_on 'Subscribe'
  end

  def pay_stripe
    click_on 'Pay for 1 loaf'
    #Capybara.current_driver = :rack_test
    #params = {"utf8"=>"✓", "stripeToken"=>"tok_104BlP4mOmZyXxlvkuSPOxa5", "stripeEmail"=>"lizzie@example.com", "action"=>"create", "controller"=>"subs", "subscriber_id"=>"1"}
    #page.driver.submit :post, subscriber_subs_path(1), params

    page.driver.browser.switch_to.frame 'stripe_checkout_app'
    fill_in "card_number", with: "4242424242424242"
    fill_in "cc-exp", with: (Date.current + 1.month).strftime('%m%y')
    fill_in "cc-csc", with: '123'

    click_on 'Pay £10 every 4 weeks'
  end

  def see_success
    sleep(15)
    expect(page).to have_content 'lizzie'
    expect(page).to have_content 'White sour'
  end

  def get_email
    open_email "lizzie@example.com"
    expect(current_email).to have_content "Somewhere in Leeds"
    expect(current_email).to have_content "Green Action"
  end


end
