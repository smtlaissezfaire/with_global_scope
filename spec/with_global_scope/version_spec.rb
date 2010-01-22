require "spec_helper"

describe WithGlobalScope do
  describe "VERSION" do
    it "should be at 0.1.0" do
      WithGlobalScope::Version::STRING.should == "0.1.0"
    end

    it "should have major as 0" do
      WithGlobalScope::Version::MAJOR.should == 0
    end

    it "should have minor as 1" do
      WithGlobalScope::Version::MINOR.should == 1
    end

    it "should have tiny as 0" do
      WithGlobalScope::Version::TINY.should == 0
    end
  end
end
