class CreateLibraries < ActiveRecord::Migration[7.0]
  def change
    create_table :libraries do |t|
      t.string :branch_name
      t.string :address
      t.integer :phone_number
      t.boolean :activated

      t.timestamps
    end
  end
end
