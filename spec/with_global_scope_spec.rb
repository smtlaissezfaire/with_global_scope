require "spec_helper"

describe WithGlobalScope do
  before do
    User.delete_all
  end

  describe "execution" do
    it "should execute the block given" do
      block_run = false

      with_global_scope = WithGlobalScope.new(lambda {})
      with_global_scope.execute(lambda do
        block_run = true
      end)

      block_run.should be_true
    end

    it "should scope a query by the value given" do
      with_global_scope = WithGlobalScope.new( lambda { |model| model.by_first_name("scott") } )

      u1 = create_user(:first_name => "scott")
      u2 = create_user(:first_name => "stephen")

      with_global_scope.execute(lambda do
        User.find(:all).should == [u1]
      end)
    end

    it "should restore the find method after a call" do
      with_global_scope = WithGlobalScope.new( lambda { |model| model.by_first_name("scott") } )

      u1 = create_user(:first_name => "scott")
      u2 = create_user(:first_name => "stephen")

      with_global_scope.execute(lambda {})

      User.find(:all).should == [u1, u2]
    end

    it "should use the value given" do
      with_global_scope = WithGlobalScope.new(lambda { |model| model.by_first_name("stephen") })

      u1 = create_user(:first_name => "scott")
      u2 = create_user(:first_name => "stephen")

      with_global_scope.execute(lambda do
        User.find(:all).should == [u2]
      end)
    end

    it "should scope by the variable given" do
      with_global_scope = WithGlobalScope.new(lambda { |model| model.by_last_name("taylor") })

      u1 = create_user(:last_name => "schor")
      u2 = create_user(:last_name => "taylor")

      with_global_scope.execute(lambda do
        User.find(:all).should == [u2]
      end)
    end

    it "should scope multiple classes" do
      with_global_scope = WithGlobalScope.new( lambda { |model| model.by_first_name("scott") })

      user_1 = create_user(:first_name => "scott")
      user_2 = create_user(:first_name => "stephen")

      admin_1 = create_admin(:first_name => "scott")
      admin_2 = create_admin(:first_name => "stephen")

      with_global_scope.execute(lambda do
        User.find(:all).should          == [user_1]
        Administrator.find(:all).should == [admin_1]
      end)
    end

    it "should restore the finder if there is an error in the block" do
      with_global_scope = WithGlobalScope.new(lambda { |model| model.by_first_name("scott") })

      user_1 = create_user(:first_name => "scott")
      user_2 = create_user(:first_name => "stephen")

      begin
        with_global_scope.execute(lambda do
          raise Exception
        end)
      rescue Exception
      end

      User.find(:all).should == [user_1, user_2]
    end
  end
end