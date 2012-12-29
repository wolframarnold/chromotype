module DeferredAttribute
  def deferred_attribute(*names)
    names.each do |name|
      class_eval <<-RUBY
        def #{name}
          defined?(@#{name}) ? @#{name} : @#{name} = get_#{name}()
        end
      RUBY
    end
  end
end