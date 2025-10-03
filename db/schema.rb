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

ActiveRecord::Schema[7.0].define(version: 2025_10_02_180004) do
  create_table "basket_line_items", force: :cascade do |t|
    t.integer "basket_id", null: false
    t.integer "product_catalogue_id", null: false
    t.decimal "price", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "offer_id"
    t.index ["basket_id"], name: "index_basket_line_items_on_basket_id"
    t.index ["offer_id"], name: "index_basket_line_items_on_offer_id"
    t.index ["product_catalogue_id"], name: "index_basket_line_items_on_product_catalogue_id"
  end

  create_table "baskets", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "delivery_charges", force: :cascade do |t|
    t.integer "product_catalogue_id", null: false
    t.decimal "lower_limit"
    t.decimal "upper_limit"
    t.decimal "delivery_cost"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_catalogue_id"], name: "index_delivery_charges_on_product_catalogue_id"
  end

  create_table "offers", force: :cascade do |t|
    t.string "description", limit: 255
    t.integer "product_catalogue_id", null: false
    t.integer "offer_product_catalogue_id", null: false
    t.decimal "offer_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "trigger_count", default: 1, null: false
    t.index ["offer_product_catalogue_id"], name: "index_offers_on_offer_product_catalogue_id"
    t.index ["product_catalogue_id"], name: "index_offers_on_product_catalogue_id"
  end

  create_table "product_catalogues", force: :cascade do |t|
    t.string "product_name", limit: 255
    t.string "code", limit: 255
    t.decimal "price", precision: 10, scale: 2
    t.string "image_url", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "basket_line_items", "baskets"
  add_foreign_key "basket_line_items", "offers"
  add_foreign_key "basket_line_items", "product_catalogues"
  add_foreign_key "delivery_charges", "product_catalogues"
  add_foreign_key "offers", "product_catalogues"
  add_foreign_key "offers", "product_catalogues", column: "offer_product_catalogue_id"
end
