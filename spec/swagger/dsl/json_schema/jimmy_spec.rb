RSpec.describe Swagger::DSL::JsonSchema::Jimmy do
  subject { described_class.dsl(&block) }

  context "" do
    let(:block) do
      lambda do |domain|
        object do
          integer :id, minimum: 1
          string :name, min_length: 1
          boolean :flag
          cref :refs, :target
          array :obj do
            cref :aa
          end

          require all - :flag - :obj - :refs
        end
      end
    end

    let(:schema) do
      {
        "type" => "object",
        "properties" => {
          "id" => { "type" => "integer", "minimum" => 1 },
          "name" => { "type" => "string", "minLength" => 1 },
          "flag" => { "type" => "boolean" },
          "refs" => { "$ref" => "#/components/schemas/target" },
          "obj" => { "type" => "array", "items" => { "$ref" => "#/components/schemas/aa" } },
        },
        "required" => %w[id name],
        "additionalProperties" => false,
      }
    end

    it_is_asserted_by { subject == schema }
  end
end
