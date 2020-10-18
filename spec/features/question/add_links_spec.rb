require 'rails_helper'

feature 'User can add links to question', %q{
 In order to provide additional info to my question
 As an question's author
 I'd like to be able to add links
} do

  given(:user_author) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/svslight/2961d14ca27abfbd66d86c1211d8dba9' }
  given(:google_url) { 'https://google.com' }

  background do
    sign_in(user_author)
    visit new_question_path
  end

  scenario 'User adds multiple links when asks question', js: true do
    fill_in 'question_title', with: 'MyTitle'
    fill_in 'question_body', with: 'MyBody'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Add Links'

    within all('.nested-fields')[1] do
      fill_in 'Link name', with: 'My google'
      fill_in 'Url', with: google_url
    end
 
    click_on 'Ask'
 
    expect(page).to have_link 'My gist', href: gist_url
    expect(page).to have_link 'My google', href: google_url
  end

  scenario 'User adds link with invalid URL when asks question', js: true do
    fill_in 'Title', with: 'MyTitle'
    fill_in 'Body', with: 'MyBody'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: 'Error'

    click_on 'Ask'

    expect(page).not_to have_content 'Links url is not a valid URL'
  end
end
