require "spec"
require "sqlite3"
require "active_record"

require File.expand_path(File.dirname(__FILE__) + "/../lib/with_global_scope")

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
  named_scope :by_first_name, lambda { |name|
    {
      :conditions => {:first_name => name}
    }
  }

  named_scope :by_last_name, lambda { |name|
    {
      :conditions => {:last_name => name}
    }
  }
end

class Administrator < ActiveRecord::Base
  named_scope :by_first_name, lambda { |name|
    {
      :conditions => {:first_name => name}
    }
  }
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


