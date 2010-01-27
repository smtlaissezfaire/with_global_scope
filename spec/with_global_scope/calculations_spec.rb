require "spec_helper"

describe WithGlobalScope do
  describe "calculations" do
    include WithGlobalScope::Helper

    before do
      User.delete_all
    end

    it "should scope a count(*) query" do
      User.create!(:first_name => "scott")
      User.create!(:first_name => "bridget")

      scope = lambda { |model| model.by_first_name("scott") }

      with_global_scope(scope) do
        User.count.should == 1
      end
    end

    it "should find the correct number" do
      User.create!(:first_name => "scott")
      User.create!(:first_name => "bridget")

      scope = lambda { |model| model.by_first_name("rachel") }

      with_global_scope(scope) do
        User.count.should == 0
      end
    end
  end
end