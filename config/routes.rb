Rails.application.routes.draw do
  devise_for :users

  devise_scope :user do
    get "/users/service", to: "users#service"
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  api_version(:module => "V1", :path => {:value => "v1"}) do

    get '/home',  to: 'home#index'
    get '/import',  to: 'home#import'
    
    get '/profiles/search', to: 'profiles#search'
    put '/profiles', to: 'profiles#update'
    get '/profiles/my', to: 'profiles#my'
    post '/profiles/add_experties/:id', to: 'profiles#add_experties'
    post '/profiles/remove_experties/:id', to: 'profiles#remove_experties'



    post '/roles/abilities', to: 'roles#abilities'

    get '/roles/abilities/delete', to: 'roles#remove_ability'
    
    get '/uploads/delete', to: 'uploads#destroy'
    
    get '/users/role', to: 'users#role'

    get '/courses/search', to: 'courses#search'

    get '/courses/faculties', to: 'courses#faculties'

    get '/courses/faculties/:faculty_id', to: 'courses#faculty'
    get '/courses/sections', to: 'courses#sections'
    get '/courses/sections/:section_id', to: 'courses#section'
    

    

    resources :profiles
    resources :roles
    resources :users
    resources :courses
    

    post '/users/assignments', to: 'users#assignments'
    get '/users/assignments/delete', to: 'users#delete_assignment'
    post '/users/login', to: 'users#login'
    post '/users/verify', to: 'users#verify'
    post '/users/sign_up', to: 'users#sign_up'
    post '/users/validate_token', to: 'users#validate_token'

  end
end
