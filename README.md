# Swagger::DSL

Swagger (OpenAPI 3) DSL

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'swagger-dsl'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install swagger-dsl

## Usage

see also [swagger-serializer](https://github.com/Narazaka/swagger-serializer)

```ruby
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
      cref! UserSerializer # "#/components/User"
    end

    render 200, dsl: :jimmy do # another json schema dsl by "jimmy" gem
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

Swagger::DSL.current["info"] = {
  "title" => "my app",
  "version" => "0.1.0",
}

JSON.dump(Swagger::DSL.current.as_json)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Narazaka/swagger-dsl.
