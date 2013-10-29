match "/knowledgebase", :to => "knowledgebase#index", :via => :get
match "/knowledgebase/search", :to => "knowledgebase#search", :via => :get

scope "/knowledgebase" do
  resources :categories, :via => [:get, :post]
  resources :articles do
    collection do
      get "tagged"
      post "preview"
    end
    get "comment"
    member do
      put  "preview"
      post "add_comment"
      post "destroy_comment"
      post "rate"
    end
  end
end

RedmineApp::Application.routes.draw do
  match 'projects/:id/knowledgebase_project_settings/:action', :controller => 'knowledgebase_project_settings', :via => [:get, :post, :put]
end
