class BooksController < ApplicationController
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!, except:[:home]
  before_action :authenticate_admin!, only:[:create_book, :create_book_csv, :edit_book, :delete_book ]
  
  def home
   
    @books = Book.where('activated = 1').order('title')

    if params[:title].present?
      @books= @books.where("title ILIKE ?", "%#{params[:title]}%")
    end

  end

  def create_book

    book_id = params[:id]
    params_copies = params[:copies].to_i
    qnty_exist_copies = 0
    
    @book = Book.new if book_id.blank?
    @book = Book.find(book_id) if !book_id.blank?
   
    @book.title = params[:title]
    @book.author = params[:author]
    @book.genre = params[:genre]
    @book.subgenre = params[:subgenre]
    @book.pages = params[:pages]
    @book.publisher = params[:publisher]
    @book.copies = params_copies
    @book.save

    qnty_exist_copies = CopyBook.where('copy_books.deactived_copy = 0 and books_id=?',book_id).count  if !book_id.blank?
    qnty_exist_copies = qnty_exist_copies.to_i   

    if qnty_exist_copies < params_copies

      cont_copies = 1
      add_copies = (params_copies - qnty_exist_copies)
      while cont_copies <= add_copies do

        new_copy_number = qnty_exist_copies + cont_copies
        copy_book = CopyBook.where('copy_books.deactived_copy = 1 and books_id=? and copy_number=?',book_id, new_copy_number).take
        copy_book = CopyBook.new if copy_book.blank?
        copy_book.deactived_copy = 0 if !copy_book.blank?
        copy_book.books_id = @book.id
        copy_book.copy_number = new_copy_number
        copy_book.save
        cont_copies += 1

      end
    elsif qnty_exist_copies > params_copies

      quit_copy = (qnty_exist_copies - params_copies)
      new_number_copy = params_copies
     
      while new_number_copy < qnty_exist_copies  do
        
        copy_book = CopyBook.where('deactived_copy = 0 and copy_number=? and books_id=?',qnty_exist_copies,book_id ).take
        copy_book.deactived_copy = 1
        copy_book.save
        qnty_exist_copies -= 1
      end
    end

    if !book_id.blank?

      new_available_copies = CopyBook.where('deactived_copy = 0 and copy_status=0 and books_id=?',book_id).count
      available_copies_book = Book.find(@book.id)
      available_copies_book.copies = new_available_copies
      available_copies_book.save
      
    end

    redirect_to '/', notice: "Book created"

  end

  def create_book_csv

    require 'csv'

    file = params[:file_csv]
    cont_books = 0
    qnty_exist_copies = 0
    name_file = file.original_filename

    table = CSV.parse(File.read(file.tempfile), headers: true)
    
    if !file.blank?
      table.each_with_index do |sh,idx|

        params_copies = sh[6].to_i

        title_book = sh[0]
        @book_csv = Book.where('title=?',title_book).take if !title_book.blank?
        @book_csv = Book.new if @book_csv.blank?
        @book_csv.title = title_book
        @book_csv.author = sh[1]
        @book_csv.genre = sh[2]
        @book_csv.subgenre = sh[3]
        @book_csv.pages = sh[4]
        @book_csv.publisher = sh[5]
        @book_csv.copies = params_copies
        @book_csv.save

        cont_books +=1

        qnty_exist_copies = CopyBook.where('copy_books.deactived_copy = 0 and books_id=?',@book_csv).count  if !@book_csv.blank?
        qnty_exist_copies = qnty_exist_copies.to_i   
    
        if qnty_exist_copies < params_copies
    
          cont_copies = 1
          add_copies = (params_copies - qnty_exist_copies)
          
          while cont_copies <= add_copies do
    
            new_copy_number = qnty_exist_copies + cont_copies
            copy_book = CopyBook.where('copy_books.deactived_copy = 1 and books_id=? and copy_number=?',@book_csv, new_copy_number).take
            copy_book = CopyBook.new if copy_book.blank?
            copy_book.deactived_copy = 0 if !copy_book.blank?
            copy_book.books_id = @book_csv.id
            copy_book.copy_number = new_copy_number
            copy_book.save
            cont_copies += 1
    
          end
        elsif qnty_exist_copies > params_copies
    
          quit_copy = (qnty_exist_copies - params_copies)
          new_number_copy = params_copies
         
          while new_number_copy < qnty_exist_copies  do
            
            copy_book = CopyBook.where('copy_books.deactived_copy = 0 and copy_number=? and books_id=?',qnty_exist_copies,@book_csv ).take
            copy_book.deactived_copy = 1
            copy_book.save
            qnty_exist_copies -= 1
          end
        end
        
      end

      redirect_to '/books/new_book.html', notice: "Total books processed #{cont_books}"
    else
      redirect_to '/books/new_book.html', notice: "No Records"
    end
    
    
  end

  def edit_book
    book_id=params[:id]
    @books = Book.find(book_id)
    @copies_edit_book = CopyBook.where('books_id=? and copy_books.deactived_copy = 0',book_id).count
  end

  def delete_book

    book_id=params[:id]
    @book_delete = Book.find(book_id)
    @book_delete.activated = 0
    @book_delete.save

    redirect_to '/', notice: "Book deleted"
    
  end

  def borrow_book

    book_id = params[:id]

    copies_borrow = CopyBook.where('deactived_copy = 0 and copy_status = 0 and books_id=?',book_id ).first


    copy_number = copies_borrow.copy_number

    @borrow = BorrowBook.new
    @borrow.book_id = book_id
    @borrow.user_id = current_user.id
    @borrow.copy_number = copy_number
    @borrow.borrow_date = DateTime.current.to_date
    @borrow.due_date = (DateTime.current.to_date + 7)
    @borrow.copy_book_id = copies_borrow.id
    @borrow.save

    copy_book = CopyBook.find(copies_borrow.id)
    copy_book.copy_status = 1
    copy_book.save

    new_number_copies =  (CopyBook.where('deactived_copy = 0 and copy_status = 0 and books_id=?',book_id ).count).to_i

    book = Book.find(book_id)
    book.copies = new_number_copies
    book.save

    redirect_to '/books/my_books.html', notice:"Book borrowed"
    
  end

  def my_books
    
    @my_books = BorrowBook.where('user_id=?',current_user.id).order('status')
    time_end = DateTime.current.to_date

  end

  def return_book

    borrow_id = params[:id]
    borrow_book = BorrowBook.find(borrow_id)
    borrow_book.return_date = DateTime.current.to_date
    borrow_book.status = 1
    borrow_book.save

    book = Book.find(borrow_book.book_id)
   
    copy_book = CopyBook.where('copy_books.deactived_copy = 0 and books_id=? and copy_number=?', book.id, borrow_book.copy_number ).take  
    copy_book.copy_status = 0
    copy_book.save

    new_number_copies = (CopyBook.where('deactived_copy = 0 and copy_status = 0 and books_id=?',book.id ).count).to_i

    book.copies = new_number_copies
    book.save

    redirect_to '/books/my_books', notice: "Book returned"

  end

  def book_detail

    book_id = params[:id]
    @book = Book.find(book_id)
   
    @copy_book_details = CopyBook.getTitle(book_id)

  end

  def copy_history

    copy_id = params[:id]
    copy_book = CopyBook.find(copy_id)
    
    @copy_history_details = CopyBook.getcopyhistory(copy_book.books_id,copy_book.copy_number)

  end

end
