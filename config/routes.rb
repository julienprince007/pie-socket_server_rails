Rails.application.routes.draw do
  resources :rooms do
    resources :room_messages
  end
  resources :user
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
