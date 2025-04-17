# config/routes.rb

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'rcad/processar', to: 'rcad#processar'
    end
  end
end
