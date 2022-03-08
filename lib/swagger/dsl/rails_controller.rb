require_relative "../dsl"
require_relative "./operation"

module Swagger
  class DSL < Hash
    module RailsController
      class NotMatch < StandardError; end
      class NotExactMatch < StandardError; end

      def swagger(action, format = :json, path: nil, method: nil, &block)
        if Swagger::DSL.current.config.lazy_define_paths
          Swagger::DSL.current.define_paths_procs <<
            -> { swagger_define_path(action, format, path: path, method: method, &block) }
        else
          swagger_define_path(action, format, path: path, method: method, &block)
        end
      end

      def swagger_define_path(action, format = :json, path: nil, method: nil, &block)
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
        method = %w[put patch] if %w[put patch].include?(method)
        path ||= route.path.spec.to_s.sub("(.:format)", "").gsub(/:(\w+)/, "{\\1}")

        operation_id = "#{name}##{action}.#{method}"
        operation = Swagger::DSL::Operation.new(operation_id, format: format, &block)
        Swagger::DSL.current["paths"][path] ||= {}
        Array(method).each { |single_method| Swagger::DSL.current["paths"][path][single_method] = operation }
      end

      alias_method :oas3, :swagger
    end
  end
end
