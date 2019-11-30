require_relative "./parameters_in_type"

module Swagger
  class DSL
    class Parameters < Array
      def initialize(format: :json, &block)
        @format = format
        instance_eval(&block)
      end

      %i[path query header cookie].each do |in_type|
        define_method(in_type) do |*args, &block|
          args.empty? ? ParametersInType.new(self, in_type, &block) : self << Parameter.new(*args, in: in_type, &block)
        end
      end
    end
  end
end
