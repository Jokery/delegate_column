module ActiveRecord
  class Base
    class << self

      def delegated_columns
        @delegated_columns ||= {}
      end

      def delegate_columns(*args)
        options = args.pop
        raise ArgumentError, "last parameter must to a hash" if !options.is_a?(Hash)
        to = options[:to]
        raise ArgumentError, "Must specify exist reflections first" if reflections[to].nil?

        args.each do |column|
          delegated_columns[column] = options[:to]
        end
      end

    end
  end
end

module ActiveRecord
  class Relation
    private
    def build_where_with_delegate(opts, other = [])
      @klass.delegated_columns.each do |key, to|
        if opts.key?(key)
          v = opts.delete key
          opts[reflections[to].table_name] = { key => v }
          includes_values << to unless includes_values.include? to
        end
      end if opts.is_a?(Hash)
      build_where_without_delegate(opts, other)
    end
    alias_method_chain :build_where, :delegate
  end
end
