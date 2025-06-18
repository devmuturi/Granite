# frozen_string_literal: true

# Check if the SQLite3Adapter is defined before monkey-patching it
if defined?(ActiveRecord::ConnectionAdapters::SQLite3Adapter)
  ActiveRecord::ConnectionAdapters::SQLite3Adapter.class_eval do
    alias_method :original_initialize, :initialize

    # Override the initialize method to add a custom SQLite function: REGEXP
    def initialize(*args)
      original_initialize(*args)

      # Define a custom SQL REGEXP function for use in ActiveRecord queries
      raw_connection.create_function('regexp', 2) do |func, pattern, expr|
        begin
          regex = Regexp.new(pattern.to_s, Regexp::IGNORECASE)
          func.result = expr.to_s.match?(regex) ? 1 : 0
        rescue RegexpError
          func.result = 0
        end
      end
    end
  end
end
