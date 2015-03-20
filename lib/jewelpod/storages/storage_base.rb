require 'rubygems/package'
require 'jewelpod/uploaded_gem'

module Jewelpod
  module Storages
    class StorageBase
      def store(uploaded_file)
        gem = UploadedGem.new(uploaded_file)
        gem.validate!
        write_and_index(gem)
      end

      def write_and_index(gem)
        raise NotImplementedError
      end
    end
  end
end
