class CopyBook < ApplicationRecord

  enum copy_status: [:available, :borrow]
  after_initialize :set_default_copy_status, :if => :new_record?
  def set_default_copy_status
    self.copy_status ||= :available
  end

  enum deactived_copy: [:no, :yes]
  after_initialize :set_default_deactived_copy, :if => :new_record?
  def set_default_deactived_copy
    self.deactived_copy ||= :no
  end

  def self.getdetailborrow(book_id)
		CopyBook.select('copy_books.*, books.title, borrow_books.due_date, users.email')
		.joins('left join borrow_books on borrow_books.copy_number= copy_books.copy_number')
        .joins('left join books on books.id = copy_books.books_id')
        .joins('left join users on users.id = borrow_books.user_id')
        .where('copy_books.deactived_copy = 0 and copy_books.books_id =?',book_id)
	end

  def self.getTitle(book_id)
    CopyBook.select('copy_books.*, books.title')
    .joins('left join books on books.id = copy_books.books_id')
    .where('copy_books.deactived_copy = 0 and copy_books.books_id =?',book_id)
  end

  def self.getcopyhistory(book_id,copy_number)
		CopyBook.select('borrow_books.*,books.title, users.email')
		.joins('inner join borrow_books on borrow_books.book_id= copy_books.books_id')
    .joins('inner join books on books.id = borrow_books.book_id')
    .joins('inner join users on users.id = borrow_books.user_id')
    .where('copy_books.deactived_copy = 0 and copy_books.books_id =?',book_id)
    .where('borrow_books.copy_number =?',copy_number)
    .group('borrow_books.id, books.id, users.email')
    .order('borrow_books.id desc')
  end

  


end
