Rails.application.routes.draw do
  root 'home#index'   #show about our application on this one

  resources :users

  # root 'mails#index'

  # get 'create' => 'mails#create'

  get 'mails' => 'mails#index'        #to get all the mails
  
  get 'mails/new' => 'mails#new'    #to reply on a thread or create a new email
  post 'mails/create' => 'mails#create'   #for posting the data for new email

  get 'mails/assign' => 'mails#assign'      #to assign an email to employee
  post 'mails/:index' => 'mails#assign_to', as: :assign_to        #to post data while assigning

  get 'mails/view' => 'mails#view'    #to view an email

  get 'account/new' => 'mails#new_account'    #for email account view, for which the app will work
  post 'account/create' => 'mails#create_account'  #to post data for adding a new account




end
