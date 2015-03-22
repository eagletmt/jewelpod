require 'pathname'
require 'rack/file'
require 'rubygems/indexer'
require 'tempfile'
require 'jewelpod/storages/storage_base'

module Jewelpod
  module Storages
    class File < StorageBase
      BUFSIZ = 8192

      def initialize(uri)
        @root = Pathname.new(uri.path)
        @file_server = Rack::File.new(@root)
      end

      def serve(env)
        @file_server.call(env)
      end

      private

      def write_and_index(gem)
        dir = @root.join('gems')
        dir.mkpath
        dir.join(gem.filename).open('w') do |f|
          gem.open do |g|
            buf = ''
            while g.read(BUFSIZ, buf)
              f.write(buf)
            end
          end
        end
        create_index
      end

      def create_index
        Gem::Indexer.new(@root).generate_index
      end

      def load_specs
        @root.join("specs.#{Gem.marshal_version}").open { |f| Marshal.load(f) }
      end

      def load_spec(filename)
        @root.join('quick', "Marshal.#{Gem.marshal_version}", "#{filename}.gemspec.rz").open do |f|
          Marshal.load(Gem.inflate(f.read))
        end
      end
    end
  end
end
