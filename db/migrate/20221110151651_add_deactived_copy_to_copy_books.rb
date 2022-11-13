class AddDeactivedCopyToCopyBooks < ActiveRecord::Migration[7.0]
  def change
    add_column :copy_books, :deactived_copy, :integer, default: 0
  end
end
