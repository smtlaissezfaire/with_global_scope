class WithGlobalScope
  module Version
    MAJOR = 0
    MINOR = 0
    TINY  = 0

    STRING = "#{MAJOR}.#{MINOR}.#{TINY}"
  end

  module Helper
    def with_global_scope(finder_lambda, &block)
      WithGlobalScope.new(finder_lambda).execute(block)
    end
  end

  def initialize(finder)
    @finder = finder
  end

  def execute(a_block)
    swap_in_find
    a_block.call
  ensure
    swap_out_find
  end

private

  def swap_in_find
    finder_proc = @finder

    active_record_eval do
      if !defined?(__find_aliased_by_with_global_scope)
        alias_method :__find_aliased_by_with_global_scope, :find

        define_method :find do |*args|
          finder_proc.call(self).__find_aliased_by_with_global_scope(*args)
        end
      end
    end
  end

  def swap_out_find
    active_record_eval do
      alias_method  :find, :__find_aliased_by_with_global_scope
      remove_method :__find_aliased_by_with_global_scope
    end
  end

  def active_record_eval(&block)
    ActiveRecord::Base.metaclass.instance_eval(&block)
  end
end
