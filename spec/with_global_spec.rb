require "spec_helper"

describe WithGlobal do
  before do
    User.delete_all
  end

  it "should have the variable & value" do
    with_global = WithGlobal.new(:foo, "bar")
    with_global.variable.should == :foo
    with_global.value.should == "bar"
  end

  it "should have the correct variable & value" do
    with_global = WithGlobal.new(:bar, "baz")
    with_global.variable.should == :bar
    with_global.value.should == "baz"
  end

  describe "execution" do
    it "should execute the block given" do
      block_run = false

      with_global = WithGlobal.new(:foo, 1)
      with_global.execute(lambda do
        block_run = true
      end)

      block_run.should be_true
    end

    it "should scope a query by the value given" do
      with_global = WithGlobal.new(:first_name, "scott")

      u1 = create_user(:first_name => "scott")
      u2 = create_user(:first_name => "stephen")

      with_global.execute(lambda do
        User.find(:all).should == [u1]
      end)
    end

    it "should use the value given" do
      with_global = WithGlobal.new(:first_name, "stephen")

      u1 = create_user(:first_name => "scott")
      u2 = create_user(:first_name => "stephen")

      with_global.execute(lambda do
        User.find(:all).should == [u2]
      end)
    end

    it "should scope by the variable given" do
      with_global = WithGlobal.new(:last_name, "taylor")

      u1 = create_user(:last_name => "schor")
      u2 = create_user(:last_name => "taylor")

      with_global.execute(lambda do
        User.find(:all).should == [u2]
      end)
    end

    it "should scope multiple classes" do
      with_global = WithGlobal.new(:first_name, "scott")

      user_1 = create_user(:first_name => "scott")
      user_2 = create_user(:first_name => "stephen")

      admin_1 = create_admin(:first_name => "scott")
      admin_2 = create_admin(:first_name => "stephen")

      with_global.execute(lambda do
        User.find(:all).should          == [user_1]
        Administrator.find(:all).should == [admin_1]
      end)
    end

    it "should restore the finder if there is an error in the block" do
      with_global = WithGlobal.new(:first_name, "scott")

      user_1 = create_user(:first_name => "scott")
      user_2 = create_user(:first_name => "stephen")

      begin
        with_global.execute(lambda do
          raise Exception
        end)
      rescue Exception
      end

      User.find(:all).should == [user_1, user_2]
    end

    it "should not scope a model which does not respond to the column" do
      with_global = WithGlobal.new(:foo, "bar")

      user_1 = create_user(:first_name => "scott")
      user_2 = create_user(:first_name => "stephen")

      with_global.execute(lambda do
        User.find(:all).should == [user_1, user_2]
      end)
    end
  end
end