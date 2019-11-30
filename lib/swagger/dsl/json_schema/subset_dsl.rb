require "json/schema/subset/dsl"
require_relative "../../dsl"

module Swagger
  class DSL
    class JsonSchema
      class SubsetDSL
        def self.dsl(&block)
          options = Swagger::DSL.current.config.dsl_options
          Json::Schema::Subset::DSL.new(options: options, &block).compile!
        end
      end
    end
  end
end
