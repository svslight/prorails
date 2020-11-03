require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'Github' do
    # введем те данные которые хотим увидеть
    # чтобы эта проверка сработала нужно сэмулировать поведение этого вызова
    # (request.env['omniauth.auth']) таким образом чтобы он вернул указанные данные
    # проверим что метод берет данные из нужного места 
    let(:oauth_data) { {'provider' => 'github', 'uid' => 123 } }

    it 'finds user from oauth data' do

      # напишем параметры (аргументы) с которыми ожидаем вызов этого метода
      # через опцию .with(oauth_data) - если ожидаем возврат то можно написать
      # .and_return(user)
      # тест не прошед - получили nil вместо {'provider' => 'github', 'uid' => 123 }
      # теперь чтобы проверить что все работает правильно сэмулируем тест: 
      # и нужно указать заглушку если вызывается с другими параметрами отличными от (omniauth.auth) 
      # и выполняем это действие так как  оно реализовано (and_call_original)
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)

      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :github
    end

    context 'user exists' do
      # понадобиться user(создадим)
      # указываем (!) так как он понадобится перед каждым тестом
      let!(:user) { create(:user) }

      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :github
      end

      # делаем проверку на find_for_oauth но чтобы метод возвращал конкретное значение
      # ставим and_return(значение которое хотим вернуть )
      # find_for_oauth - метод вызываться не будет 
      # респект перехватит вызов этого метода и если он будет вызван 
      # вернет значение без выполнения метода
      it 'login user' do
        # проверяем что польз-ль залогинен и равен пользователю который вернулся
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user does not exist' do
      before do
        allow(User).to receive(:find_for_oauth) #.and_return(user)
        get :github
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end

      it 'does not login user' do
        # объекта нет
        expect(subject.current_user).to_not be
      end
    end

  end
end
