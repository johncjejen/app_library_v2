class BorrowBook < ApplicationRecord
  belongs_to :book
  belongs_to :user

  enum status: [:borrowed, :returned]
  after_initialize :set_default_status, :if => :new_record?
  def set_default_status
    self.status ||= :borrow
  end

  def self.getoverdue
		BorrowBook.select('books.title, borrow_books.id,borrow_books.borrow_date, borrow_books.return_date,borrow_books.due_date,borrow_books.status, users.email')
    .joins('inner join books on books.id = borrow_books.book_id')
    .joins('inner join users on users.id = borrow_books.user_id')
    .where("borrow_books.due_date > ?", DateTime.current.to_date)
  end

  
end
