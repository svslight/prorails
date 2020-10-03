require 'rails_helper'

feature 'User can sign up', %q(
  In order to ask questions and answers
  I'd like to be able to sign up
) do

  # given(:user) { create(:user) }

  background { visit new_user_registration_path }

  scenario 'User successfully signs up' do
    fill_in 'Email', with: 'newuser@test.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    within('form') { click_on 'Sign up' }

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'User unsuccessfully signs up' do
    within('form') { click_on 'Sign up' }

    expect(page).to have_content "Email can't be blank"
    expect(page).to have_content "Password can't be blank"
  end  
end
