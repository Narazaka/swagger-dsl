require_relative "../dsl"
require_relative "./operation"

module Swagger
  class DSL < Hash
    module RailsController
      class NotMatch < StandardError; end
      class NotExactMatch < StandardError; end

      def swagger(action, format = :json, path: nil, method: nil, &block)
        operation_id = "#{name}##{action}"

        defaults = { action: action.to_s, controller: name.underscore.sub(/_controller$/, "") }
        route = Rails.application.routes.routes.routes.find { |r| r.required_defaults == defaults }
        unless route
          raise NotMatch,
                "route not found! specify additional :path and :method key like { path: '/foos/{id}', method: 'get'}"
        end
        method ||= route.verb.downcase
        if method.include?("|")
          raise NotExactMatch, "route matched but verb can be #{verb}! specify :method key like 'get'."
        end
        method = ["put", "patch"] if ["put", "patch"].include?(method)
        path ||= route.path.spec.to_s.sub("(.:format)", "").gsub(/:(\w+)/, "{\\1}")

        operation = Swagger::DSL::Operation.new(operation_id, format: format, &block)
        Swagger::DSL.current["paths"][path] ||= {}
        Array(method).each do |single_method|
          Swagger::DSL.current["paths"][path][single_method] = operation
        end
      end

      alias_method :oas3, :swagger
    end
  end
end
