require_relative "../dsl"
require_relative "./operation"

module Swagger
  class DSL
    module RailsController
      # TODO: path, method detection
      def swagger(action, format = :json, path:, method:, &block)
        operation_id = "#{name}##{action}"
        operation = Swagger::DSL::Operation.new(operation_id, format: format, &block)
        Swagger::DSL.current["paths"][path] ||= {}
        Swagger::DSL.current["paths"][path][method] = operation
      end

      alias_method :oas3, :swagger
    end
  end
end
