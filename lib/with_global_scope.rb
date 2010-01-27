class WithGlobalScope
  module Version
    MAJOR = 0
    MINOR = 1
    TINY  = 0

    STRING = "#{MAJOR}.#{MINOR}.#{TINY}"
  end

  module Helper
    def with_global_scope(finder_lambda, &body)
      WithGlobalScope.new(finder_lambda).execute(body)
    end
  end

  def initialize(finder)
    @finder = finder
  end

  def execute(body_lambda)
    swap_in_find
    body_lambda.call
  ensure
    swap_out_find
  end

private

  def swap_in_find
    finder_proc = @finder

    [:find, :calculate].each do |method_name|
      alias_name = create_alias_name(method_name)

      active_record_eval do
        unless methods.include?(alias_name)
          alias_method alias_name, method_name

          define_method method_name do |*args|
            finder_proc.call(self).send(alias_name, *args)
          end
        end
      end
    end
  end

  def swap_out_find
    [:find, :calculate].each do |method_name|
      alias_name = create_alias_name(method_name)

      active_record_eval do
        alias_method method_name, alias_name
        remove_method alias_name
      end
    end
  end

  def create_alias_name(method_name)
    "_#{method_name}_aliased_by_with_global_scope"
  end

  def active_record_eval(&block)
    ActiveRecord::Base.metaclass.instance_eval(&block)
  end
end
