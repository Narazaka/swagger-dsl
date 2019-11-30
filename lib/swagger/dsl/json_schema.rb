require_relative "./json_schema/subset_dsl"
require_relative "./json_schema/jimmy"
require_relative "../dsl"

module Swagger
  class DSL
    class JsonSchema
      def self.by(dsl_type = nil)
        dsl_type ||= Swagger::DSL.current.config.default_dsl
        dsl_type == :jimmy ? Jimmy : SubsetDSL
      end
    end
  end
end
