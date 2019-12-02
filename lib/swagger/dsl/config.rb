module Swagger
  class DSL < Hash
    class Config
      attr_accessor :inject_key, :default_dsl, :dsl_options, :eager, :default_required

      def initialize(inject_key: "title", default_dsl: nil, dsl_options: nil, eager: false, default_required: true)
        @inject_key = inject_key
        @default_dsl = default_dsl
        @dsl_options ||= { reference_name: ->(name) { name.sub(/Serializer$/, "") } }
        @eager = eager
        @default_required = default_required
      end
    end
  end
end
