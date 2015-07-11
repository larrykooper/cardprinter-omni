# config/routes.rb
Rails.application.routes.draw do
  root to: 'sessions#new'
  resources :sessions, only: :index
  get "/auth/:provider/callback" => 'sessions#create'
  get 'spreadsheet/getdata/:sheet' => 'spreadsheets#getdata'
  post 'printcards' => 'cardgenerators#generate_cards'
end

