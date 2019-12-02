require_relative "./json_schema"
require_relative "./parameters"
require_relative "../dsl"

module Swagger
  class DSL < Hash
    class Operation < Hash
      FORMAT_TYPE = {
        json: "application/json",
        xml: "application/xml",
        plain: "text/plain",
        html: "text/html",
        csv: "text/csv",
        form: "application/x-www-form-urlencoded",
      }.freeze

      def initialize(operation_id, format: :json, &block)
        self["operationId"] = operation_id
        self["requestBody"] = { "content" => {}, "required" => true }
        self["responses"] = {}
        self["parameters"] = []
        @format = format
        instance_eval(&block)
      end

      def params(default_required: Swagger::DSL.current.config.default_required, &block)
        self["parameters"] = Parameters.new(default_required: default_required, &block)
      end

      def body(format: @format, dsl: nil, &block)
        formats(format).each do |f|
          self["requestBody"]["content"][f] = {
            "schema" => Swagger::DSL::JsonSchema.by(dsl).dsl(&block)
          }
        end
      end

      def body_description(body_description = nil)
        self["requestBody"]["description"] = body_description
      end

      def body_optional(optional = true)
        self["requestBody"]["required"] = optional
      end

      def render(code = 200, format: @format, dsl: nil, &block)
        self["responses"][code] ||= { "content" => {} }
        formats(format).each do |f|
          self["responses"][code]["content"][f] = {
            "schema" => Swagger::DSL::JsonSchema.by(dsl).dsl(&block)
          }
        end
      end

      private

      def formats(format)
        Array(format).map { |f| FORMAT_TYPE[f] }
      end
    end
  end
end
