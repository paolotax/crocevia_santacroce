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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121023064052) do

  create_table "articoli", :force => true do |t|
    t.string   "nome"
    t.integer  "quantita"
    t.decimal  "prezzo",          :precision => 7, :scale => 2
    t.integer  "provvigione"
    t.integer  "cliente_id"
    t.integer  "categoria_id"
    t.datetime "created_at",                                                   :null => false
    t.datetime "updated_at",                                                   :null => false
    t.integer  "movimenti_count",                               :default => 0
    t.integer  "documento_id"
    t.string   "index"
  end

  add_index "articoli", ["categoria_id"], :name => "index_articoli_on_categoria_id"
  add_index "articoli", ["cliente_id"], :name => "index_articoli_on_cliente_id"
  add_index "articoli", ["documento_id"], :name => "index_articoli_on_documento_id"
  add_index "articoli", ["index"], :name => "index_articoli_on_index"
  add_index "articoli", ["nome"], :name => "index_articoli_on_nome"

  create_table "categorie", :force => true do |t|
    t.string   "nome"
    t.integer  "provvigione"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "clienti", :force => true do |t|
    t.string   "nome"
    t.string   "cognome"
    t.string   "ragione_sociale"
    t.string   "indirizzo"
    t.string   "cap"
    t.string   "citta"
    t.string   "provincia"
    t.string   "partita_iva"
    t.string   "codice_fiscale"
    t.string   "tipo_documento"
    t.string   "numero_documento"
    t.date     "data_rilascio_documento"
    t.integer  "numero_tessera"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.string   "documento_rilasciato_da"
    t.string   "telefono"
    t.string   "cellulare"
    t.string   "email"
    t.text     "note"
    t.string   "slug"
    t.date     "data_di_nascita"
    t.string   "comune_di_nascita"
    t.string   "sesso"
    t.string   "index"
  end

  add_index "clienti", ["index"], :name => "index_clienti_on_index"
  add_index "clienti", ["slug"], :name => "index_clienti_on_slug"

  create_table "conversations", :force => true do |t|
    t.string   "subject",    :default => ""
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "documenti", :force => true do |t|
    t.string   "tipo"
    t.date     "data"
    t.decimal  "importo",    :precision => 7, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                :null => false
    t.datetime "updated_at",                                                :null => false
  end

  create_table "friendly_id_slugs", :force => true do |t|
    t.string   "slug",                         :null => false
    t.integer  "sluggable_id",                 :null => false
    t.string   "sluggable_type", :limit => 40
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], :name => "index_friendly_id_slugs_on_slug_and_sluggable_type", :unique => true
  add_index "friendly_id_slugs", ["sluggable_id"], :name => "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], :name => "index_friendly_id_slugs_on_sluggable_type"

  create_table "movimenti", :force => true do |t|
    t.string   "tipo"
    t.integer  "quantita",                                   :default => 1
    t.decimal  "prezzo",       :precision => 7, :scale => 2
    t.integer  "articolo_id"
    t.datetime "created_at",                                                :null => false
    t.datetime "updated_at",                                                :null => false
    t.integer  "documento_id"
    t.integer  "user_id"
    t.integer  "rimborso_id"
  end

  add_index "movimenti", ["articolo_id"], :name => "index_movimenti_on_articolo_id"
  add_index "movimenti", ["documento_id"], :name => "index_movimenti_on_documento_id"
  add_index "movimenti", ["rimborso_id"], :name => "index_movimenti_on_rimborso_id"
  add_index "movimenti", ["user_id"], :name => "index_movimenti_on_user_id"

  create_table "notifications", :force => true do |t|
    t.string   "type"
    t.text     "body"
    t.string   "subject",              :default => ""
    t.integer  "sender_id"
    t.string   "sender_type"
    t.integer  "conversation_id"
    t.boolean  "draft",                :default => false
    t.datetime "updated_at",                              :null => false
    t.datetime "created_at",                              :null => false
    t.integer  "notified_object_id"
    t.string   "notified_object_type"
    t.string   "notification_code"
    t.string   "attachment"
  end

  add_index "notifications", ["conversation_id"], :name => "index_notifications_on_conversation_id"

  create_table "photos", :force => true do |t|
    t.string   "photo"
    t.integer  "message_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "photos", ["message_id"], :name => "index_photos_on_message_id"

  create_table "receipts", :force => true do |t|
    t.integer  "receiver_id"
    t.string   "receiver_type"
    t.integer  "notification_id",                                  :null => false
    t.boolean  "is_read",                       :default => false
    t.boolean  "trashed",                       :default => false
    t.boolean  "deleted",                       :default => false
    t.string   "mailbox_type",    :limit => 25
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
  end

  add_index "receipts", ["notification_id"], :name => "index_receipts_on_notification_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "name"
    t.string   "provider"
    t.string   "uid"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

  add_foreign_key "notifications", "conversations", :name => "notifications_on_conversation_id"

  add_foreign_key "receipts", "notifications", :name => "receipts_on_notification_id"

end
