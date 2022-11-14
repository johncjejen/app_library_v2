# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_11_13_201616) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "books", force: :cascade do |t|
    t.string "title"
    t.string "author"
    t.string "genre"
    t.string "subgenre"
    t.integer "pages"
    t.string "publisher"
    t.integer "copies"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "activated", default: 1
    t.bigint "library_id", null: false
    t.index ["library_id"], name: "index_books_on_library_id"
  end

  create_table "borrow_books", force: :cascade do |t|
    t.bigint "book_id", null: false
    t.bigint "user_id", null: false
    t.integer "copy_number"
    t.date "borrow_date"
    t.date "due_date"
    t.date "return_date"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "copy_book_id"
    t.index ["book_id"], name: "index_borrow_books_on_book_id"
    t.index ["copy_book_id"], name: "index_borrow_books_on_copy_book_id"
    t.index ["user_id"], name: "index_borrow_books_on_user_id"
  end

  create_table "copy_books", force: :cascade do |t|
    t.bigint "books_id", null: false
    t.integer "copy_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "copy_status", default: 0
    t.integer "deactived_copy", default: 0
    t.index ["books_id"], name: "index_copy_books_on_books_id"
  end

  create_table "libraries", force: :cascade do |t|
    t.string "branch_name"
    t.string "address"
    t.integer "phone_number"
    t.boolean "activated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "role", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "books", "libraries"
  add_foreign_key "borrow_books", "books"
  add_foreign_key "borrow_books", "users"
end
