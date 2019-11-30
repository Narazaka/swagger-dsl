require_relative "./dsl/config"
require_relative "./dsl/version"
require_relative "./dsl/rails_controller"
require_relative "./dsl/serializer"
require_relative "./dsl/components"

module Swagger
  class DSL < Hash
    class << self
      def current
        @current ||= new
      end
    end

    attr_reader :paths, :components, :config

    def initialize(openapi: nil, info: nil, paths: nil, components: nil, config: Config.new)
      self["openapi"] = openapi || "3.0"
      self["info"] = info || {}
      self["paths"] = paths || {}
      self["components"] = components || Components.new
      @config = config
    end
  end
end
