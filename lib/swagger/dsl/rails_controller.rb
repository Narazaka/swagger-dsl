require_relative "../dsl"
require_relative "./operation"

module Swagger
  class DSL
    module RailsController
      def swagger(action, format = :json, &block)
        operation_id = "#{name}##{action}"
        path, method = [operation_id, "get"] # TODO
        operation = Swagger::DSL::Operation.new(operation_id, format: format, &block)
        Swagger::DSL.current.paths[path] ||= {}
        Swagger::DSL.current.paths[path][method] = operation
      end

      alias_method :oas3, :swagger
    end
  end
end
