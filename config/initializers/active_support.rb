module ActiveSupport
  def self.migration_safe_on_load &block
    self.on_load(:active_record) do
      begin
        block.yield
      rescue ActiveRecord::StatementInvalid => e
        if /Table '[\S]+' doesn't exist/ =~ e.message
          # The db migrations need to run
        else
          # We don't know what this exception is about. Raise.
          raise e
        end
      end
    end
  end
end