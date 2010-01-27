class WithGlobalScope
  module Version
    MAJOR = 0
    MINOR = 1
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
      unless methods.include?("_find_aliased_by_with_global_scope")
        alias_method :_find_aliased_by_with_global_scope, :find

        define_method :find do |*args|
          finder_proc.call(self)._find_aliased_by_with_global_scope(*args)
        end

        alias_method :_calculate_aliased_by_with_global_scope, :calculate

        define_method :calculate do |operation, column_name, *args|
          options = args.first || {}
          finder_proc.call(self)._calculate_aliased_by_with_global_scope(operation, column_name, options)
        end
      end
    end
  end

  def swap_out_find
    active_record_eval do
      alias_method  :find, :_find_aliased_by_with_global_scope
      remove_method :_find_aliased_by_with_global_scope

      alias_method  :calculate, :_calculate_aliased_by_with_global_scope
      remove_method :_calculate_aliased_by_with_global_scope
    end
  end

  def active_record_eval(&block)
    ActiveRecord::Base.metaclass.instance_eval(&block)
  end
end
