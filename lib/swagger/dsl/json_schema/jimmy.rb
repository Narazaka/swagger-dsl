require "jimmy"
require_relative "./jimmy_patch"

module Swagger
  class DSL < Hash
    class JsonSchema
      class Jimmy
        DOMAIN = ::Jimmy::Domain.new("")

        def self.dsl(&block)
          DOMAIN.instance_eval(&block).schema.compile
        end
      end
    end
  end
end
