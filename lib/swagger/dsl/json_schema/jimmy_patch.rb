require_relative "../../dsl"

# rubocop:disable Airbnb/ClassOrModuleDeclaredInWrongFile, Airbnb/ModuleMethodInWrongFile
module Jimmy
  class SchemaCreation
    module Referencing
      def component(id)
        name = "#/components/schemas/#{id}"
        reference_name = Swagger::DSL.current.config.dsl_options[:reference_name]
        reference_name ? reference_name.call(name) : name
      end

      def cref(*args, uri, &block)
        ref(*args, component(uri), &block)
      end
    end
  end
end
# rubocop:enable Airbnb/ClassOrModuleDeclaredInWrongFile, Airbnb/ModuleMethodInWrongFile
