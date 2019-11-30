require_relative "./dsl/config"
require_relative "./dsl/version"
require_relative "./dsl/rails_controller"
require_relative "./dsl/serializer"

module Swagger
  class DSL
    class << self
      def current
        @current ||= new
      end
    end

    attr_reader :paths, :components, :config

    def initialize(config: Config.new)
      @paths = {}
      @components = {}
      @config = config
    end

    def to_schema
      paths =
        @paths.map do |path, methods|
          [path, methods.map { |method, operation| [method, operation.to_schema] }.to_h]
        end.to_h
      { openapi: "3.0", info: @config.info, paths: paths, components: @components }
    end
  end
end
