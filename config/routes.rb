Rails.application.routes.draw do
  use_doorkeeper

  root to: "questions#index"

  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }  

  concern :voteable do
    member do
      post :vote_up
      post :vote_down
    end
  end

  concern :commentable do
    resources :comments, only: :create
  end

  resources :questions, concerns: %i[voteable commentable], shallow: true do
    resources :answers, concerns: %i[voteable commentable], except: :index do
      post :mark_best, on: :member
    end
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [] do
        get :me, on: :collection
      end

      resources :questions, only: [:index]
    end
  end
  
  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index

  mount ActionCable.server => '/cable'  
end
