require_relative "./parameter"

module Swagger
  class DSL < Hash
    class ParametersInType
      def initialize(parent, type, parameter_options, &block)
        @parent = parent
        @type = type
        @parameter_options = parameter_options
        instance_eval(&block)
      end

      def respond_to_missing?(name, include_private)
        true
      end

      def method_missing(name, *args, &block)
        @parent << Parameter.new(@parameter_options, name, *args, in: @type, &block)
      end
    end
  end
end
