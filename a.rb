{
  "openapi" => "3.0",
  "info" => {},
  "paths" => {
    "/users/{id}" => {
      "put" => {
        "operationId" => "UsersController#update",
        "requestBody" => {
          "content" => { "application/json" => { "schema" => { "$ref" => "#/components/User" } } }, "required" => true
        },
        "responses" => {
          200 => {
            "content" => {
              "application/json" => {
                "schema" => {
                  "type" => "object",
                  "properties" => {
                    "status" => { "type" => "string", "default" => :ok, "enum" => %w[ok] },
                    "user" => { "$ref" => "#/components/User" },
                  },
                  "required" => %w[status user],
                  "additionalProperties" => false,
                },
              },
            },
          },
        },
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
