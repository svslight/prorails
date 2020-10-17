require 'rails_helper'

feature 'User can add links to question', %q{
 In order to provide additional info to my question
 As an question's author
 I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/svslight/2961d14ca27abfbd66d86c1211d8dba9' }
  given(:user_url) { 'https://google.com' }

  scenario 'User adds link when asks question' do

    sign_in(user)
    visit new_question_path
 
    fill_in 'question_title', with: 'MyTitle'
    fill_in 'question_body', with: 'MyBody'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url
 
    click_on 'Ask'
 
    expect(page).to have_link 'My gist', href: gist_url
  end

end
