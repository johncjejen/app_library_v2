class AddLibrariesToBooks < ActiveRecord::Migration[7.0]
  def change
    add_reference :books, :library, null: false, foreign_key: true
  end
end
