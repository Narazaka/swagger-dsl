require_relative "./json_schema"

module Swagger
  class DSL < Hash
    class Parameter < Hash
      def initialize(options, *args, &block)
        @default_required = options[:default_required]
        self["required"] = true if @default_required

        unless args.empty?
          self["name"] = args.first
          args[1..-1].each { |arg| merge!(arg.map { |k, v| [k.to_s, v] }.to_h) }
          canonical_schema!
          delete("required") unless self["required"]
        end
        instance_eval(&block) if block_given?
      end

      def schema(types = nil, dsl: nil, &block)
        self["schema"] = types ? types : Swagger::DSL::JsonSchema.by(dsl).dsl(&block)
        canonical_schema!
      end

      %w[description deprecated allowEmptyValue style explode allowReserved example examples].each do |name|
        define_method(name) { |value| self[name] = value }
      end

      def required(value)
        if value
          self["required"] = true
        else
          delete("required")
        end
      end

      private

      def canonical_schema!
        self["schema"] = { "type" => self["schema"] } if !self["schema"].nil? && !self["schema"].is_a?(Hash)
      end
    end
  end
end
