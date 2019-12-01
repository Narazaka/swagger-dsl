require_relative "../rails_fixture"

RSpec.describe Swagger::DSL::ResolveModule do
  describe "#resolved" do
    subject do
      Swagger::DSL.current.resolved["paths"]["/users/{id}"]["patch"]["requestBody"]["content"]["application/json"][
        "schema"
      ]
    end

    let(:schema1) { Swagger::DSL.current["components"]["User"] }

    it_is_asserted_by { subject == schema1 }
  end

  describe "#resolve" do
    subject do
      Swagger::DSL.current.resolve({ "$ref" => "#/components/User" })
    end

    let(:schema1) { Swagger::DSL.current["components"]["User"] }

    it_is_asserted_by { subject == schema1 }
  end

  describe "#resolver" do
    subject do
      Swagger::DSL.current.resolver.call({ "$ref" => "#/components/User" })
    end

    let(:schema1) { Swagger::DSL.current["components"]["User"] }

    it_is_asserted_by { subject == schema1 }
  end
end
