require "json_refs"
require "hana"
require "active_support/core_ext/object/deep_dup"

module Swagger
  class DSL
    module ResolveModule
      def resolved
        JsonRefs.call(deep_dup)
      end

      def resolver
        method(:resolve)
      end

      def resolve(part_schema)
        walk(resolved, part_schema)
      end

      private

      def walk(all, part)
        if part.is_a?(Array)
          part.map { |item| walk(all, item) }
        elsif part.is_a?(Hash)
          ref = part["$ref"] || part[:"$ref"]
          ref ? walk(all, Hana::Pointer.new(ref[1..-1]).eval(all)) : part.map { |k, v| [k, walk(all, v)] }.to_h
        else
          part
        end
      end
    end
  end
end
