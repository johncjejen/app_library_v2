class CreateCopyBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :copy_books do |t|
      t.references :books, null: false
      t.integer :copy_number

      t.timestamps
    end
  end
end
