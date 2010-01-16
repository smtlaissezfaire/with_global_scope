require "spec_helper"

describe WithGlobal::Helper do
  before do
    klass = Class.new do
      include WithGlobal::Helper
    end

    @obj = klass.new
  end

  it "should be a module" do
    WithGlobal::Helper.class.should == Module
  end

  it "should have the with_global method" do
    @obj.should respond_to(:with_global)
  end

  it "should create a new WithGlobal" do
    mock_with_global = mock(WithGlobal, :null_object => true)
    WithGlobal.should_receive(:new).and_return mock_with_global

    @obj.with_global :season, 1 do
    end
  end

  it "should pass in the var & value" do
    mock_with_global = mock(WithGlobal, :null_object => true)
    WithGlobal.should_receive(:new).with(:season, 1).and_return mock_with_global

    @obj.with_global :season, 1 do
    end
  end

  it "should pass in the correct var & value" do
    mock_with_global = mock(WithGlobal, :null_object => true)
    WithGlobal.should_receive(:new).with(:foo, :bar).and_return mock_with_global

    @obj.with_global :foo, :bar do
    end
  end

  it "should execute the block given" do
    lambda_expression = lambda { }

    mock_with_global = mock(WithGlobal, :execute => nil)
    WithGlobal.stub!(:new).and_return mock_with_global

    mock_with_global.should_receive(:execute).with(lambda_expression)

    @obj.with_global :foo, :bar, &lambda_expression
  end
end