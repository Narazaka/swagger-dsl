# mocks

require "active_support/core_ext/string/inflections"

class Rails
  def self.application
    Struct.new(:routes).new(
      Struct.new(:routes).new(
        Struct.new(:routes).new(
          [
            Struct.new(:verb, :path, :required_defaults).new("get", Struct.new(:spec).new("/users"), { action: "index", controller: "users" }),
            Struct.new(:verb, :path, :required_defaults).new("patch", Struct.new(:spec).new("/users/{id}"), { action: "update", controller: "users" }),
          ],
        ),
      ),
    )
  end
end

class BaseSerializer
  extend Swagger::DSL::Serializer
end

class Api
  class UserSerializer < BaseSerializer
    swagger do
      id :integer
      name :string
      age :integer, minimum: 18
    end
  end
end

class ApplicationController
  extend Swagger::DSL::RailsController
end

class UsersController < ApplicationController
  swagger :index do
    render 200 do
      array! { cref! Api::UserSerializer }
    end
  end

  def index
    # some
  end

  swagger :update do
    summary "Update a user"
    description "Lorem ipsum dolor sit amet."
    tags "Users", "Updates"
    params do
      path :id, schema: :integer
      query do
        safe schema: :boolean, required: false
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
      cref! Api::UserSerializer
    end

    render 200, dsl: :jimmy do
      object do
        string :status, enum: %w[ok], default: :ok
        cref :user, Api::UserSerializer
        require all
      end
    end
  end

  def update
    # some
  end
end

Swagger::DSL.current["info"] = { "title" => "my app", "version" => "0.1.0" }
