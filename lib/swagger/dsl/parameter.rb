require_relative "./json_schema"

module Swagger
  class DSL
    class Parameter < Hash
      def initialize(*args, &block)
        unless args.empty?
          self["name"] = args.first
          args[1..-1].each { |arg| merge!(arg.map { |k, v| [k.to_s, v] }.to_h) }
          canonical_schema!
        end
        instance_eval(&block) if block_given?
      end

      def schema(types = nil, dsl: nil, &block)
        self["schema"] = types ? types : Swagger::DSL::JsonSchema.by(dsl).dsl(&block)
        canonical_schema!
      end

      %w[description required deprecated allowEmptyValue style explode allowReserved example examples].each do |name|
        define_method(name) { |value| self[name] = value }
      end

      private

      def canonical_schema!
        self["schema"] = { "type" => self["schema"] } if !self["schema"].nil? && !self["schema"].is_a?(Hash)
      end
    end
  end
end
