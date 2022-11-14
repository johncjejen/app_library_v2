Rails.application.routes.draw do
  root 'books#home'
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :books do

    get :new_book
    post :create_book
    post :create_book_csv
    get :my_books
    post :overdue_book
    get :home

  end

  namespace :library do

    get :new_library
    post :create_library
    get :home

  end

  get "edit_book/:id" => 'books#edit_book'
  get "delete_book/:id" => 'books#delete_book'
  get "history_book/:id" => 'books#history_book'
  get "book_detail/:id" => 'books#book_detail'
  get "book_detail/copy_history/:id" => 'books#copy_history'
  get "return_book/:id" => 'books#return_book'
  get "borrow_book/:id" => 'books#borrow_book'

  get "library/edit_library/:id" => 'library#edit_library'
  get "library/delete_library/:id" => 'library#delete_library'
  get "library/library_detail/:id" => 'library#library_detail'
 

end
