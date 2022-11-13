class AddCopyStatusToCopyBooks < ActiveRecord::Migration[7.0]
  def change
    add_column :copy_books, :copy_status, :integer, default: 0
  end
end
