module Swagger
  class DSL
    class Config
      attr_accessor :inject_key, :default_dsl, :info, :dsl_options

      def initialize(inject_key: "title", default_dsl: nil, dsl_options: nil, info: {})
        @inject_key = inject_key
        @default_dsl = default_dsl
        @info = info
        @dsl_options ||= { reference_name: ->(name) { name.sub(/Serializer$/, "") } }
      end
    end
  end
end
