require_relative "../dsl"
require_relative "./json_schema"

module Swagger
  class DSL < Hash
    module Serializer
      def swagger(dsl: nil, &block)
        name = self.name.sub(/Serializer$/, "").gsub(/::/, '-')
        Swagger::DSL.current["components"]["schemas"][name] =
          Swagger::DSL::JsonSchema.by(dsl).dsl(&block).merge(Swagger::DSL.current.config.inject_key => name)
      end

      alias_method :oas3, :swagger
    end
  end
end
