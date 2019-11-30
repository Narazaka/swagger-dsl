require_relative "./json_schema"
require_relative "./parameters"

module Swagger
  class DSL
    class Operation < Hash
      FORMAT_TYPE = {
        json: "application/json", xml: "application/xml", plain: "text/plain", html: "text/html", csv: "text/csv"
      }.freeze

      def initialize(operation_id, format: :json, &block)
        self["operationId"] = operation_id
        self["requestBody"] = { "content" => {}, "required" => true }
        self["responses"] = {}
        self["parameters"] = []
        @format = format
        instance_eval(&block)
      end

      def params(&block)
        self["parameters"] = Parameters.new(&block)
      end

      def body(format: @format, dsl: nil, &block)
        self["requestBody"]["content"][FORMAT_TYPE[format]] = {
          "schema" => Swagger::DSL::JsonSchema.by(dsl).dsl(&block)
        }
      end

      def body_description(body_description = nil)
        self["requestBody"]["description"] = body_description
      end

      def body_optional(optional = true)
        self["requestBody"]["required"] = optional
      end

      def render(code = 200, format: @format, dsl: nil, &block)
        self["responses"][code] ||= { "content" => {} }
        self["responses"][code]["content"][FORMAT_TYPE[format]] = {
          "schema" => Swagger::DSL::JsonSchema.by(dsl).dsl(&block)
        }
      end
    end
  end
end
