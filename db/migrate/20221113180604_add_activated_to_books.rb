class AddActivatedToBooks < ActiveRecord::Migration[7.0]
  def change
    add_column :books, :activated, :integer, default: 1
  end
end
