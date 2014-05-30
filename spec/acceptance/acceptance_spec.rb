require 'spec_helper'

feature "New user, new sign-up", type: :feature,  js: true  do
  before :each do
    create :collection_point
    create :bread_type
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
    expect(page).to have_content "Name"
    expect(page).to have_content "Phone"
    expect(page).to have_content "Bread type"
  end

  def fill_in_details
    fill_in 'Name',       with: 'Lizzie'
    fill_in "Email",      with: 'lizzie@example.com'
    fill_in "Address",    with: 'Somewhere in Leeds'
    fill_in "Phone",      with: '01132222222'
    select 'Green Action', from: :subscriber_collection_point_id
    fill_in "Start date", with: ((Date.current + 14.days).at_beginning_of_week + 2.days).strftime # future Wed
    select 'Rye Sour Loaf', from: :subscriber_bread_type_id
    fill_in "Password",   with: 'password'
    fill_in "Notes",      with: 'Thanks!'

    click_on 'Subscribe'
  end

  def pay_stripe
    click_on 'Pay for the bread'
    page.driver.browser.switch_to.frame 'stripe_checkout_app'
    fill_in "card_number", with: "4242424242424242"
    fill_in "cc-exp", with: (Date.current + 1.month).strftime('%m%y')
    fill_in "cc-csc", with: '123'
    click_on 'Pay £10 every 4 weeks'
  end

end
