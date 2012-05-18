module Enumerable
  def to_i
    map { |ea| ea.to_i }
  end unless public_method_defined? :to_i

  def collect_hash(hash = Hash.new)
    inject(hash) do |h, i|
      y = yield(i)
      if y.nil?
        h
      elsif y.respond_to? :merge
        h.merge(y)
      elsif y.respond_to?(:first) && y.respond_to?(:last)
        h[y.first] = y.last
        h
      else
        raise "Expected yield to return nil, a hash, or a 2 element array"
      end
    end
  end
end