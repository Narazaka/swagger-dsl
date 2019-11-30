require_relative "./json_schema"
require_relative "./parameters"

module Swagger
  class DSL
    class Operation
      FORMAT_TYPE = {
        json: "application/json", xml: "application/xml", plain: "text/plain", html: "text/html", csv: "text/csv"
      }.freeze

      def initialize(operation_id, format: :json, &block)
        @operation_id = operation_id
        @format = format
        @body = {}
        @responses = {}
        instance_eval(&block)
      end

      def params(&block)
        @parameters = Parameters.new(&block)
      end

      def body(format: @format, dsl: nil, &block)
        @body[format] = Swagger::DSL::JsonSchema.by(dsl).dsl(&block)
      end

      def body_description(body_description = nil)
        @body_description = body_description
      end

      def body_optional(optional = true)
        @body_optional = optional
      end

      def render(code = 200, format: @format, dsl: nil, &block)
        @responses[code] ||= {}
        @responses[code][format] = Swagger::DSL::JsonSchema.by(dsl).dsl(&block)
      end

      def to_schema
        request_body = {
          description: @body_description,
          required: !@body_optional,
          content: @body.map { |format, schema| [FORMAT_TYPE[format], { schema: schema }] }.to_h,
        }

        responses =
          @responses.map do |code, formats|
            [code, { content: formats.map { |format, schema| [FORMAT_TYPE[format], { schema: schema }] }.to_h }]
          end.to_h

        {
          operationId: @operation_id, parameters: @parameters.to_schema, requestBody: request_body, responses: responses
        }
      end
    end
  end
end
