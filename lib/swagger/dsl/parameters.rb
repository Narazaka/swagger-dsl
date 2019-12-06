require_relative "./parameters_in_type"

module Swagger
  class DSL < Hash
    class Parameters < Array
      def initialize(default_required:, &block)
        @default_required = default_required
        instance_eval(&block)
      end

      %i[path query header cookie].each do |in_type|
        define_method(in_type) do |*args, &block|
          if args.empty?
            ParametersInType.new(self, in_type, { default_required: @default_required }, &block)
          else
            self << Parameter.new({ default_required: @default_required }, *args, in: in_type, &block)
          end
        end
      end
    end
  end
end
