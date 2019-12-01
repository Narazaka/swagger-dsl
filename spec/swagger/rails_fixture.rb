# mocks

require "active_support/core_ext/string/inflections"

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
