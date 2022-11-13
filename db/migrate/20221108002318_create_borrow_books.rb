class CreateBorrowBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :borrow_books do |t|
      t.references :book, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :copy_number
      t.date :borrow_date
      t.date :due_date
      t.date :return_date
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
