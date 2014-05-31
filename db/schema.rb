# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140531181707) do

  create_table "images", force: true do |t|
    t.string   "path"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pets", force: true do |t|
    t.string   "species"
    t.string   "name"
    t.string   "pet_id"
    t.string   "gender"
    t.boolean  "fixed"
    t.string   "breed"
    t.date     "found_on"
    t.datetime "scraped_at"
    t.integer  "shelter_id"
    t.integer  "image_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "color"
  end

  add_index "pets", ["breed"], name: "index_pets_on_breed"
  add_index "pets", ["color"], name: "index_pets_on_color"
  add_index "pets", ["fixed"], name: "index_pets_on_fixed"
  add_index "pets", ["gender"], name: "index_pets_on_gender"
  add_index "pets", ["image_id"], name: "index_pets_on_image_id"
  add_index "pets", ["pet_id"], name: "index_pets_on_pet_id"
  add_index "pets", ["shelter_id"], name: "index_pets_on_shelter_id"
  add_index "pets", ["species"], name: "index_pets_on_species"

  create_table "shelters", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
