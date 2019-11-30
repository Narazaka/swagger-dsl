require_relative "./json_schema"

module Swagger
  class DSL
    class Parameter
      def initialize(*args, &block)
        @parameter = {}
        unless args.empty?
          @parameter[:name] = args.first
          args[1..-1].each { |arg| @parameter.merge!(arg) }
        end
        instance_eval(&block) if block_given?
      end

      def to_schema
        params = @parameter.dup
        params[:schema] = { "type" => params[:schema] } unless params[:schema].is_a?(Hash)
        params
      end

      def schema(types = nil, dsl: nil, &block)
        @parameter[:schema] = types ? types : Swagger::DSL::JsonSchema.by(dsl).dsl(&block)
      end

      %i[description required deprecated allowEmptyValue style explode allowReserved example examples].each do |name|
        define_method(name) { |value| @parameter[name] = value }
      end
    end
  end
end
