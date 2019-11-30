RSpec.describe Swagger::DSL::JsonSchema::SubsetDSL do
  subject { described_class.dsl(&block) }

  context "" do
    let(:block) do
      lambda do |domain|
        title! "Foo"
        id :integer, minimum: 1
        name :string, minLength: 1
        flag :boolean, optional: true
        obj :object do
          id :integer
          foos :array, optional: true do
            string! title: "Str1"
          end
          bars :array do
            title! "Str2"
            string! minLength: 1
          end
          bazs :array do
            id :integer
          end
          hoge :object do
            cref! :aa
          end
          fuga :object do
            ref! :aa
          end
        end
      end
    end

    let(:schema) do
      {
        "type" => "object",
        "properties" => {
          "id" => { "minimum" => 1, "type" => "integer" },
          "name" => { "minLength" => 1, "type" => "string" },
          "flag" => { "type" => "boolean" },
          "obj" => {
            "type" => "object",
            "properties" => {
              "id" => { "type" => "integer" },
              "foos" => { "items" => { "title" => "Str1", "type" => "string" }, "type" => "array" },
              "bars" => { "items" => { "minLength" => 1, "type" => "string", "title" => "Str2" }, "type" => "array" },
              "bazs" => {
                "items" => {
                  "type" => "object", "properties" => { "id" => { "type" => "integer" } }, "required" => %w[id]
                },
                "type" => "array",
              },
              "hoge" => { "$ref" => "#/components/aa" },
              "fuga" => { "$ref" => "aa" },
            },
            "required" => %w[id bars bazs hoge fuga],
          },
        },
        "required" => %w[id name obj],
        "title" => "Foo",
      }
    end

    it_is_asserted_by { subject == schema }
  end
end
