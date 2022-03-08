require_relative "./json_schema"
require_relative "./parameters"
require_relative "../dsl"

module Swagger
  class DSL < Hash
    class Components < Hash
      STRING = "".freeze

      def [](name)
        # for autoload
        if !Swagger::DSL.current.config.eager && STRING.respond_to?(:classify) && STRING.respond_to?(:safe_constantize)
          serializer_name(name).classify.safe_constantize
        end
        super(name)
      end

      private

      def serializer_name(name)
        name.to_s.gsub(/-/, '::').sub(/(?:Serializer)?$/, "Serializer")
      end
    end
  end
end
