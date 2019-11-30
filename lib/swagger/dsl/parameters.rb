require_relative "./parameters_in_type"

module Swagger
  class DSL
    class Parameters
      attr_reader :parameters

      def initialize(format: :json, &block)
        @format = format
        @parameters = []
        instance_eval(&block)
      end

      def to_schema
        @parameters.map(&:to_schema)
      end

      %i[path query header cookie].each do |in_type|
        define_method(in_type) do |*args, &block|
          if args.empty?
            ParametersInType.new(self, in_type, &block)
          else
            @parameters << Parameter.new(*args, in: in_type, &block)
          end
        end
      end
    end
  end
end
