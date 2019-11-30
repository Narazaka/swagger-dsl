require_relative "./parameter"

module Swagger
  class DSL
    class ParametersInType
      def initialize(parent, type, &block)
        @parent = parent
        @type = type
        instance_eval(&block)
      end

      def respond_to_missing?(name, include_private)
        true
      end

      def method_missing(name, *args, &block)
        @parent.parameters << Parameter.new(name, *args, in: @type, &block)
      end
    end
  end
end
