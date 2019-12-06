require "json"
require_relative "./rails_fixture"

RSpec.describe Swagger::DSL do
  subject { Swagger::DSL.current }

  let(:patch) do
    {
      "operationId" => "UsersController#update",
      "parameters" => [
        { "name" => :id, "schema" => { "type" => :integer }, "required" => true, "in" => :path },
        { "name" => :safe, "schema" => { "type" => :boolean }, "in" => :query },
        {
          "name" => :redirect,
          "in" => :query,
          "required" => true,
          "schema" => { "type" => "string", "format" => "url" },
        },
      ],
      "requestBody" => {
        "required" => true,
        "content" => { "application/json" => { "schema" => { "$ref" => "#/components/User" } } },
      },
      "responses" => {
        200 => {
          "content" => {
            "application/json" => {
              "schema" => {
                "type" => "object",
                "properties" => {
                  "status" => { "enum" => %w[ok], "default" => :ok, "type" => "string" },
                  "user" => { "$ref" => "#/components/User" },
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
      "paths" => {
        "/users/{id}" => {
          "patch" => patch,
          "put" => patch,
        },
      },
      "components" => {
        "User" => {
          "type" => "object",
          "properties" => {
            "id" => { "type" => "integer" },
            "name" => { "type" => "string" },
            "age" => { "minimum" => 18, "type" => "integer" },
          },
          "required" => %w[id name age],
          "title" => "User",
        },
      },
    }
  end

  it_is_asserted_by { subject == schema }
  it_is_asserted_by { JSON.load(JSON.dump(subject)) == JSON.load(JSON.dump(schema)) }
end
