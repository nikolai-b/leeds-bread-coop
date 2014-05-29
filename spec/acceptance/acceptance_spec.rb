require 'spec_helper'

feature "New user, new sign-up", type: :feature do
  scenario "New subscription" do
    visit '/'

    click_on 'Sign up'

    see_new_user_details

    fill_in_details

    pay_stripe

    see_success

    get_email
  end

  def see_new_user_details
    expect(page).to have_content "Name"
    expect(page).to have_content "Phone"
    expect(page).to have_content "Bread Type"
  end

  def fill_in_details
    fill_in :name,    with: 'Lizzie'
    fill_in :email,   with: 'lizzie@example.com'
    fill_in :address, with: 'Somewhere in Leeds'
    fill_in :phone,   with: '01132222222'
    select 'Green Action', from: 'Collection Point'
    fill_in :start_date, with: (Date.current + 14.days).at_beginning_of_week.strftime # future Monday
    select 'Sour Dough Rye', from: 'Bread Type'
    fill_in :quantity, with: 1
    fill_in :notes, with: 'Thanks!'

    click_on 'Subscribe'
  end

  def pay_stripe
  end

end
