class Class
  class << self
    uncached_subclasses = instance_method(:subclasses)
    define_method(:subclasses) do
      @subclasses ||= uncached_subclasses
    end
  end
end
