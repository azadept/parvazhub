# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161228162307) do

  create_table "flight_prices", force: :cascade do |t|
    t.integer  "flight_id"
    t.integer  "price"
    t.string   "supplier"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.date     "flight_date"
  end

  create_table "flights", force: :cascade do |t|
    t.integer  "route_id"
    t.string   "flight_number"
    t.datetime "departure_time"
    t.string   "airline_code"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "airplane_type"
  end

  create_table "routes", force: :cascade do |t|
    t.string   "origin"
    t.string   "destination"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

end
