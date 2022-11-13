class CreateBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.string :genre
      t.string :subgenre
      t.integer :pages
      t.string :publisher
      t.integer :copies

      t.timestamps
    end
  end
end
