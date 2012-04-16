module Enumerable
  def to_i
    map { |ea| ea.to_i }
  end unless public_method_defined? :to_i
end