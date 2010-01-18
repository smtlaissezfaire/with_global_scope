require "spec_helper"

describe WithGlobalScope::Helper do
  before do
    klass = Class.new do
      include WithGlobalScope::Helper
    end

    @obj = klass.new

    @scope_lambda = a_lambda = lambda { }
  end

  it "should be a module" do
    WithGlobalScope::Helper.class.should == Module
  end

  it "should have the with_global_scope method" do
    @obj.should respond_to(:with_global_scope)
  end

  it "should create a new WithGlobalScope" do
    mock_with_global_scope = mock(WithGlobalScope, :null_object => true)
    WithGlobalScope.should_receive(:new).and_return mock_with_global_scope

    @obj.with_global_scope lambda {} do
    end
  end

  it "should pass in the block" do
    mock_with_global_scope = mock(WithGlobalScope, :null_object => true)
    WithGlobalScope.should_receive(:new).with(@scope_lambda).and_return mock_with_global_scope

    @obj.with_global_scope @scope_lambda do
    end
  end

  it "should execute the block given" do
    lambda_expression = lambda { }

    mock_with_global_scope = mock(WithGlobalScope, :execute => nil)
    WithGlobalScope.stub!(:new).and_return mock_with_global_scope

    mock_with_global_scope.should_receive(:execute).with(lambda_expression)

    @obj.with_global_scope @scope_lambda, &lambda_expression
  end
end