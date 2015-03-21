require 'aws-sdk-core'
require 'pathname'
require 'rubygems/indexer'
require 'jewelpod/storages/storage_base'

module Jewelpod
  module Storages
    class S3 < StorageBase
      def initialize(uri)
        @bucket = uri.host
        @path_prefix = uri.path.gsub(%r{\A/*}, '')
        @s3 = Aws::S3::Client.new
      end

      def serve(env)
        key = File.join(@path_prefix, env[Rack::PATH_INFO])
        header = {
          'Location' => "#{@s3.config.endpoint}/#{@bucket}/#{key}",
        }
        [302, header, '']
      end

      private

      def write_and_index(gem)
        key = File.join(@path_prefix, 'gems', gem.filename)
        gem.open do |g|
          @s3.put_object(
            body: g,
            bucket: @bucket,
            key: key,
          )
          puts "Upload gem to #{key}"
        end
        create_index
      end

      def create_index
        Dir.mktmpdir('jewelpod') do |root|
          root = Pathname.new(root)
          root.join('gems').mkpath
          gem_names = list_gems
          download_gems(root, gem_names)
          Gem::Indexer.new(root).generate_index
          remove_gems(root)
          upload_index(root, root)
        end
      end

      def list_gems
        all_gems = []
        marker = nil
        prefix = File.join(@path_prefix, 'gems', '')
        loop do
          response = @s3.list_objects(
            bucket: @bucket,
            marker: marker,
            prefix: prefix,
          )
          all_gems.concat(response.contents.map { |c| c.key[prefix.size .. -1] })
          if response.next_marker
            marker = response.next_marker
          else
            break
          end
        end
        all_gems
      end

      def download_gems(root, gem_names)
        gem_names.each do |gem_name|
          root.join('gems', gem_name).open('w') do |f|
            key = File.join(@path_prefix, 'gems', gem_name)
            puts "Download #{key} -> #{root.join('gems', gem_name)}"
            @s3.get_object(
              response_target: f,
              bucket: @bucket,
              key: key,
            )
          end
        end
      end

      def remove_gems(root)
        root.join('gems').rmtree
      end

      def upload_index(root, dir)
        dir.each_child do |child|
          if child.directory?
            upload_index(root, child)
          else
            child.open do |f|
              key = File.join(@path_prefix, child.relative_path_from(root))
              @s3.put_object(
                body: f,
                bucket: @bucket,
                key: key,
              )
            end
          end
        end
      end
    end
  end
end
