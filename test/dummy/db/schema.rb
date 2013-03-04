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

ActiveRecord::Schema.define(:version => 20130226151256) do

  create_table "alberich_base_permission_objects", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "alberich_derived_permissions", :force => true do |t|
    t.integer  "permission_id",                         :null => false
    t.integer  "role_id",                               :null => false
    t.integer  "entity_id",                             :null => false
    t.integer  "permission_object_id"
    t.string   "permission_object_type"
    t.integer  "lock_version",           :default => 0
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
  end

  add_index "alberich_derived_permissions", ["permission_id"], :name => "index_alberich_derived_permissions_on_permission_id"
  add_index "alberich_derived_permissions", ["permission_object_id", "permission_object_type"], :name => "index_alberich_derived_permissions_on_perm_obj"

  create_table "alberich_entities", :force => true do |t|
    t.string   "name"
    t.integer  "entity_target_id",                  :null => false
    t.string   "entity_target_type",                :null => false
    t.integer  "lock_version",       :default => 0
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "alberich_permission_sessions", :force => true do |t|
    t.integer  "user_id",                     :null => false
    t.string   "session_id",                  :null => false
    t.integer  "lock_version", :default => 0
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "alberich_permissions", :force => true do |t|
    t.integer  "role_id",                               :null => false
    t.integer  "entity_id",                             :null => false
    t.integer  "permission_object_id"
    t.string   "permission_object_type"
    t.integer  "lock_version",           :default => 0
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
  end

  create_table "alberich_privileges", :force => true do |t|
    t.integer  "role_id",                     :null => false
    t.string   "target_type",                 :null => false
    t.string   "action",                      :null => false
    t.integer  "lock_version", :default => 0
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "alberich_roles", :force => true do |t|
    t.string   "name",                               :null => false
    t.string   "scope",                              :null => false
    t.integer  "lock_version",    :default => 0
    t.boolean  "assign_to_owner", :default => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  create_table "alberich_session_entities", :force => true do |t|
    t.integer  "user_id",                              :null => false
    t.integer  "entity_id",                            :null => false
    t.integer  "permission_session_id",                :null => false
    t.integer  "lock_version",          :default => 0
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  create_table "child_resources", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "parent_resource_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "child_resources", ["parent_resource_id"], :name => "index_child_resources_on_parent_resource_id"

  create_table "global_resources", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "members_user_groups", :id => false, :force => true do |t|
    t.integer "user_group_id", :null => false
    t.integer "member_id",     :null => false
  end

  create_table "parent_resources", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "standalone_resources", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "user_groups", :force => true do |t|
    t.string   "name",                        :null => false
    t.string   "description"
    t.integer  "lock_version", :default => 0
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "username",                          :null => false
    t.string   "email"
    t.string   "crypted_password"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "login_count",        :default => 0, :null => false
    t.integer  "failed_login_count", :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

end
