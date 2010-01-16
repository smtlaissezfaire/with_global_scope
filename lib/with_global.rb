class WithGlobal
  module Version
    MAJOR = 0
    MINOR = 0
    TINY  = 0

    STRING = "#{MAJOR}.#{MINOR}.#{TINY}"
  end

  def initialize(variable, value)
    @variable = variable.to_sym
    @value    = value
  end

  attr_reader :variable
  attr_reader :value

  def execute
    set_global_scope
    yield
  ensure
    restore_scope
  end

private

  def set_global_scope
    var, value = @variable, @value

    ar_eval do
      alias_method :__old_current_scoped_methods, :current_scoped_methods

      define_method :current_scoped_methods do
        if column_names.include?(var.to_s)
          {
            :find => {
              :conditions => {
                var => value
              }
            }
          }
        end
      end
    end
  end

  def restore_scope
    ar_eval do
      alias_method :current_scoped_methods, :__old_current_scoped_methods
      remove_method :__old_current_scoped_methods
    end
  end

  def ar_eval(&block)
    ActiveRecord::Base.metaclass.class_eval(&block)
  end
end
