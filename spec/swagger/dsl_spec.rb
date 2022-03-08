require "json"
require_relative "./rails_fixture"

RSpec.describe Swagger::DSL do
  subject { Swagger::DSL.current }

  let(:get) do
    {
      "tags" => [],
      "operationId" => "UsersController#index",
      "parameters" => [],
      "responses" => {
        200 => {
          "description" => "200",
          "content" => {
            "application/json" => {
              "schema" => {
                "type" => "array",
                "items" => {
                  "$ref" => "#/components/schemas/Api-User",
                },
              },
            },
          },
        },
      },
    }
  end

  let(:patch) do
    {
      "summary" => "Update a user",
      "description" => "Lorem ipsum dolor sit amet.",
      "tags" => [ "Users", "Updates" ],
      "operationId" => "UsersController#update",
      "parameters" => [
        { "name" => :id, "schema" => { "type" => :integer }, "required" => true, "in" => :path },
        { "name" => :safe, "schema" => { "type" => :boolean }, "in" => :query },
        {
          "name" => :redirect, "in" => :query, "required" => true, "schema" => { "type" => "string", "format" => "url" }
        },
      ],
      "requestBody" => {
        "required" => true, "content" => { "application/json" => { "schema" => { "$ref" => "#/components/schemas/Api-User" } } }
      },
      "responses" => {
        200 => {
          "description" => "200",
          "content" => {
            "application/json" => {
              "schema" => {
                "type" => "object",
                "properties" => {
                  "status" => { "enum" => %w[ok], "default" => :ok, "type" => "string" },
                  "user" => { "$ref" => "#/components/schemas/Api-User" },
                },
                "required" => %w[status user],
                "additionalProperties" => false,
              },
            },
          },
        },
      },
    }
  end

  let(:schema) do
    {
      "openapi" => "3.0.0",
      "info" => { "title" => "my app", "version" => "0.1.0" },
      "paths" => { "/users" => { "get" => get }, "/users/{id}" => { "patch" => patch, "put" => patch } },
      "components" => {
        "schemas" => {
          "Api-User" => {
            "type" => "object",
            "properties" => {
              "id" => { "type" => "integer" },
              "name" => { "type" => "string" },
              "age" => { "minimum" => 18, "type" => "integer" },
            },
            "required" => %w[id name age],
            "title" => "Api-User",
          },
        },
      },
    }
  end

  it 'should generate expected schema' do
    expect(subject.to_json).to be_json_eql(schema.to_json)
  end

  it 'has no errors' do
    expect(Openapi3Parser.load(subject.to_json).errors).to be_empty
  end
end
