require "spec"
require "sqlite3"
require "active_record"

require File.expand_path(File.dirname(__FILE__) + "/../lib/with_global")

ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database  => ':memory:'
ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define do
  create_table :users, :force => true do |t|
    t.string :first_name
    t.string :last_name
  end

  create_table :administrators, :force => true do |t|
    t.string :first_name
    t.string :last_name
  end
end

class User < ActiveRecord::Base
end

class Administrator < ActiveRecord::Base
end

def create_user(hash={})
  u = User.new(hash)
  u.save!
  u
end

def create_admin(hash={})
  u = Administrator.new(hash)
  u.save!
  u
end


