require 'addressable/uri'

module Jewelpod
  module Storage
    class NotFound < StandardError
    end

    module ClassMethods
      def find(url)
        uri = Addressable::URI.parse(url)
        find_storage_class(uri.scheme).new(uri)
      end

      private

      def find_storage_class(type)
        require "jewelpod/storages/#{type}"
        class_name = "#{type[0].upcase}#{type[1 .. -1]}"
        Storages.const_get(class_name)
      rescue LoadError, NameError
        raise NotFound.new("storage type #{type} is not found")
      end
    end
    extend ClassMethods
  end
end
