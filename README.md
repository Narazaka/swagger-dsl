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
      path :id, schema: :integer
      query do
        safe schema: :boolean, required: false
        redirect do
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

JSON.dump(Swagger::DSL.current)
```

### required default

Body and response parameters are "required" default in default DSL.

So `params` are also default "required".

If you do not want it, `Swagger::DSL.current.config.default_required = false`.

### If Rails eager_load = true

Rails controllers will be loaded before loading the routes when eager_load is enabled.

So set `Swagger::DSL.current.config.lazy_define_paths = true`, `reload_routes!` and `Swagger::DSL.current.define_paths!`

```ruby
if Rails.application.config.eager_load
  Swagger::DSL.current.config.lazy_define_paths = true
  Rails.application.config.after_initialize do
    Rails.application.reload_routes!
    Swagger::DSL.current.define_paths!
    JSON.dump(Swagger::DSL.current)
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Narazaka/swagger-dsl.
