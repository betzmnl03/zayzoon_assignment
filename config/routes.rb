Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  resources :employers do
    post "employee_earnings", on: :member  #custom route to upload employee earnings
  end
  
  root "employers#index"
end
