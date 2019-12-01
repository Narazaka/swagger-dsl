# mocks

class String
  def underscore
    "users_controller"
  end
end

class Rails
  def self.application
    Struct.new(:routes).new(
      Struct.new(:routes).new(
        Struct.new(:routes).new(
          Class.new do
            def find
              Struct.new(:verb, :path).new("patch", Struct.new(:spec).new("/users/{id}"))
            end
          end.new,
        ),
      ),
    )
  end
end

class BaseSerializer
  extend Swagger::DSL::Serializer
end

class UserSerializer < BaseSerializer
  swagger do
    id :integer
    name :string
    age :integer, minimum: 18
  end
end

class ApplicationController
  extend Swagger::DSL::RailsController
end

class UsersController < ApplicationController
  swagger :update do
    params do
      path :id, schema: :integer, required: true
      query do
        safe schema: :boolean
        redirect do
          required true
          schema do
            string!
            format! "url"
          end
        end
      end
    end

    body do
      # name :string
      # age :integer, minimum: 18
      cref! UserSerializer
    end

    render 200, dsl: :jimmy do
      object do
        string :status, enum: %w[ok], default: :ok
        cref :user, UserSerializer
        require all
      end
    end
  end

  def update
    # some
  end
end

Swagger::DSL.current["info"] = { "title" => "my app", "version" => "0.1.0" }

RSpec.describe Swagger::DSL do
  subject { Swagger::DSL.current }

  let(:schema) do
    {
      "openapi" => "3.0.0",
      "info" => { "title" => "my app", "version" => "0.1.0" },
      "paths" => {
        "/users/{id}" => {
          "patch" => {
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
          },
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
end
