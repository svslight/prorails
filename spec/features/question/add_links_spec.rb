require 'rails_helper'

feature 'User can add links to question', %q{
 In order to provide additional info to my question
 As an question's author
 I'd like to be able to add links
} do
  # Заводим начальные данные
  # Ссылку можно прикрепить любую
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/svslight/2961d14ca27abfbd66d86c1211d8dba9' }
  given(:user_url) { 'https://google.com' }

  # background do
  #   sign_in(user)
  #   visit new_question_path
 
  #   fill_in 'question_title', with: 'MyTitle'
  #   fill_in 'question_body', with: 'MyBody'
  # end

  scenario 'User adds link when asks question' do
    # не будем проверять валидации (это относится к созданию вопроса)
    # мы должны залогинить полз-ля и перейти на стр создания вопроса
    # заполняем поля title и body для вопроса
    # заполнить 2 поля связанные со ссылками
    # далее полз-ль кликает на кнопку Ask
    # далее проверить что есть ссылка с названием 'My gist' 
    #   и что она ведет на правильный url
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
