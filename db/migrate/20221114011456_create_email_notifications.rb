class CreateEmailNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :email_notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :book, null: false, foreign_key: true
      t.date :request_date
      t.date :notification_date
      t.boolean :activated

      t.timestamps
    end
  end
end
