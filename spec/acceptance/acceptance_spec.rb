require 'spec_helper'

feature "New user, new sign-up", type: :feature,  js: true  do

  before :each do
    create :collection_point
    create :bread_type
    create :email_template, :with_real_template

    Capybara.current_driver = :selenium
    Capybara.javascript_driver = :selenium

   # Capybara.register_driver :poltergeist do |app|
   #   Capybara::Poltergeist::Driver.new(app, js_errors: false)
   # end
   # Capybara.javascript_driver = :poltergeist
   # Capybara.current_driver = :poltergeist
    StripeMock.stop
  end

  scenario "New subscription" do
    visit '/'

    click_on 'Sign up'

    see_new_user_details

    fill_in_details

    expect(page).to have_content "You have signed up successfully."

    pay_stripe

    sleep(3)

    see_success

    get_email
  end

  def see_new_user_details
    expect(page).to have_content "First name"
    expect(page).to have_content "Phone"
    expect(page).to have_content "Bread type"
  end

  def fill_in_details
    sleep(3)
    fill_in 'First name', with: 'Lizzie'
    sleep(30)
    fill_in 'Last name',  with: 'Surname'
    fill_in "Email",      with: 'lizzie@example.com'
    fill_in "Address",    with: 'Somewhere in Leeds'
    fill_in "Phone",      with: '01132222222'
    select 'Green Action', from: :subscriber_collection_point_id
    select "Wednesday",    from: "Collection day"
    select 'White Sourdough'
    fill_in "Password",   with: 'password'

    click_on 'Subscribe'
  end

  def pay_stripe
    click_on 'Pay for 1 loaf'

   # stripe = page.driver.window_handles.last

   # page.within_window stripe do
   #   fill_in "card_number", :with => "4242424242424242"
   #   fill_in "cc-exp", with: (Date.current + 1.month).strftime('%m%y')
   #   fill_in "City", :with => "Berlin"
   #   fill_in "cc-csc", with: '123'
   #   page.save_and_open_page
   #   click_button "Payment Info"

   # end
    Capybara.within_frame all('iframe[name=stripe_checkout_app]').last do
      sleep(1)

      4.times { fill_with_keys "card_number", with: '4242' }
      fill_with_keys "cc-exp", with: (Date.current + 1.month).strftime('%m')
      fill_with_keys "cc-exp", with: (Date.current + 1.month).strftime('%y')
      fill_in "cc-csc", with: '123'

      click_on 'Pay £10 every 4 weeks'
    end
  end

  def see_success
    expect(page).to have_content 'lizzie'
    expect(page).to have_content 'White Sourdough'
  end

  def get_email
    open_email "lizzie@example.com"
    expect(current_email).to have_content "Somewhere in Leeds"
    expect(current_email).to have_content "Green Action"
  end

  def fill_with_keys(el, opts)
    page.driver.browser.find_element(:id, el).send_keys(opts[:with])
  end
end
