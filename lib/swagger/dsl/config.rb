module Swagger
  class DSL
    class Config
      attr_accessor :inject_key, :default_dsl, :dsl_options, :eager

      def initialize(inject_key: "title", default_dsl: nil, dsl_options: nil, eager: false)
        @inject_key = inject_key
        @default_dsl = default_dsl
        @dsl_options ||= { reference_name: ->(name) { name.sub(/Serializer$/, "") } }
        @eager = eager
      end
    end
  end
end
