require_relative "../dsl"
require_relative "./json_schema"

module Swagger
  class DSL
    module Serializer
      def swagger(dsl: nil, &block)
        name = self.name.sub(/Serializer$/, "")
        Swagger::DSL.current.components[name] =
          Swagger::DSL::JsonSchema.by(dsl).dsl(&block).merge(Swagger::DSL.current.config.inject_key => name)
      end

      alias_method :oas3, :swagger
    end
  end
end
