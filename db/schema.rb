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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110610033254) do

  create_table "authentications", :force => true do |t|
    t.string   "provider",   :null => false
    t.string   "uid",        :null => false
    t.integer  "rubyist_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contributions", :force => true do |t|
    t.integer  "rubyist_id",        :null => false
    t.integer  "ruby_kaigi_id",     :null => false
    t.string   "contribution_type", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "order_item_id"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "event_rooms", :force => true do |t|
    t.integer  "event_id"
    t.integer  "room_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_rubyists", :force => true do |t|
    t.integer  "event_id"
    t.integer  "rubyist_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_time_slits", :force => true do |t|
    t.integer  "event_id"
    t.integer  "time_slit_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.string   "title_en"
    t.string   "title_ja"
    t.text     "abstract_en"
    t.text     "abstract_ja"
    t.string   "detail_en"
    t.string   "detail_ja"
    t.string   "additional_info"
    t.string   "lang"
    t.string   "required_equipment"
    t.integer  "parent_event_id"
    t.boolean  "break"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "presenter_name"
    t.text     "presenter_profile_ja"
    t.text     "presenter_profile_en"
    t.string   "presentation_material"
    t.integer  "vimeo_id"
    t.string   "nicovideo_id"
  end

  create_table "headline_entries", :force => true do |t|
    t.text     "title"
    t.datetime "time"
    t.text     "link"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "language"
  end

  add_index "headline_entries", ["language"], :name => "index_headline_entries_on_language"
  add_index "headline_entries", ["time"], :name => "index_headline_entries_on_time"

  create_table "individual_sponsor_options", :force => true do |t|
    t.integer  "additional_amount", :default => 0,     :null => false
    t.string   "link_label"
    t.string   "link_url"
    t.boolean  "attend_party",      :default => false, :null => false
    t.integer  "order_item_id",                        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "anonymous",         :default => false
  end

  create_table "order_items", :force => true do |t|
    t.integer  "order_id",                       :null => false
    t.integer  "product_item_id",                :null => false
    t.integer  "quantity",        :default => 1, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "unit_price",      :default => 0, :null => false
  end

  create_table "orders", :force => true do |t|
    t.integer  "rubyist_id",                                        :null => false
    t.boolean  "return_from_paypal",             :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "purchased_at"
    t.integer  "price",                          :default => 0,     :null => false
    t.integer  "paypal_payment_notification_id"
    t.integer  "ruby_kaigi_id",                  :default => 5,     :null => false
    t.string   "invoice_code",                                      :null => false
  end

  create_table "paypal_payment_notifications", :force => true do |t|
    t.string   "payment_status",          :null => false
    t.string   "txn_id"
    t.string   "receipt_id"
    t.string   "payer_email"
    t.string   "last_name"
    t.string   "first_name"
    t.string   "payer_id"
    t.string   "address_zip"
    t.string   "address_state"
    t.string   "address_city"
    t.string   "address_street"
    t.string   "address_name"
    t.string   "payment_date"
    t.integer  "tax"
    t.text     "notified_params_as_json", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "invoice"
  end

  create_table "product_items", :force => true do |t|
    t.string   "item_code",                         :null => false
    t.integer  "unit_price",                        :null => false
    t.integer  "stock",          :default => 0,     :null => false
    t.integer  "ruby_kaigi_id",                     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "open_sale_at"
    t.boolean  "ready_for_sale", :default => false, :null => false
  end

  add_index "product_items", ["item_code"], :name => "index_product_items_on_item_code", :unique => true

  create_table "rooms", :force => true do |t|
    t.string   "name_en"
    t.string   "name_ja"
    t.string   "floor_en"
    t.string   "floor_ja"
    t.integer  "sort_order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ruby_kaigis", :force => true do |t|
    t.integer  "year",                                :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "capacity",             :default => 0, :null => false
    t.integer  "party_capacity",       :default => 0, :null => false
    t.datetime "registration_open_at"
  end

  add_index "ruby_kaigis", ["year"], :name => "index_ruby_kaigis_on_year", :unique => true

  create_table "rubyists", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.integer  "twitter_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "identity_url"
    t.string   "full_name"
    t.string   "website"
    t.string   "avatar_type",     :default => "default", :null => false
  end

  add_index "rubyists", ["identity_url"], :name => "index_rubyists_on_identity_url", :unique => true
  add_index "rubyists", ["twitter_user_id"], :name => "index_rubyists_on_twitter_user_id", :unique => true
  add_index "rubyists", ["username"], :name => "index_rubyists_on_username", :unique => true

  create_table "tickets", :force => true do |t|
    t.string   "ticket_code",       :null => false
    t.string   "ticket_type",       :null => false
    t.string   "code4url",          :null => false
    t.string   "name",              :null => false
    t.string   "email",             :null => false
    t.integer  "contribution_id"
    t.integer  "rubyist_id"
    t.integer  "ruby_kaigi_id",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "extra_ticket_type"
  end

  create_table "time_slits", :force => true do |t|
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
