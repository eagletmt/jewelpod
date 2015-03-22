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

      def get_dependencies(gem_names)
        specs = load_specs
        list = []
        specs.each do |name, version, platform|
          if gem_names.include?(name)
            list << to_result_hash(name, version, platform)
          end
        end
        list
      end

      private

      def load_specs
        raise NotImplementedError
      end

      def load_spec(filename)
        raise NotImplementedError
      end

      def to_result_hash(name, version, platform)
        {
          name: name,
          number: version.version,
          platform: platform,
          dependencies: runtime_dependencies(name, version, platform),
        }
      end

      def runtime_dependencies(name, version, platform)
        filename = [name, version.version]
        if platform != 'ruby'
          filename << platform
        end
        load_spec(filename.join('-')).runtime_dependencies.map do |dep|
          [dep.name, dep.requirement.to_s]
        end
      end
    end
  end
end
