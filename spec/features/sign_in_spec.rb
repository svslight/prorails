require 'rails_helper'

feature 'User can sign in', %q{
  In order to ask questions
  As an unauthenticated user
  I'm like to be able to sing in
} do
  
  describe 'Log in with email and password' do
    given(:user) { create(:user) }

    background { visit new_user_session_path }
  
    scenario 'Registered user tries to sign in' do
      fill_in 'Email', with: user.email    
      fill_in 'Password', with: user.password
      click_on 'Log in'
  
      expect(page).to have_content 'Signed in successfully.'
    end
  
    scenario 'Unregistered user tries to sign in' do
      fill_in 'Email', with: 'wrong@test.com'    
      fill_in 'Password', with: '12345678'
      click_on 'Log in'
  
      expect(page).to have_content 'Invalid Email or password.'
    end 
  end

  describe 'Log In With Github' do
    scenario 'success log in' do
      visit new_user_session_path
      mock_auth_hash_github
      click_on 'Sign in with GitHub'

      expect(page).to have_content 'Successfully authenticated from Github account.'
      expect(page).to have_content'Log out'
    end
  end

  describe 'Log In With VK' do
    scenario 'success log in' do
      visit new_user_session_path
      mock_auth_hash_vkontakte
      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'Successfully authenticated from VK account.'
      expect(page).to have_content 'Log out'
    end
  end 
end
