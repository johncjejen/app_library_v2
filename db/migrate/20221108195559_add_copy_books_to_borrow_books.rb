class AddCopyBooksToBorrowBooks < ActiveRecord::Migration[7.0]
  def change
    add_reference :borrow_books, :copy_book
  end
end
