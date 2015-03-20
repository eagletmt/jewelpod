require 'pathname'

module Jewelpod
  class UploadedGem
    class InvalidGem < StandardError
    end

    def initialize(uploaded_file)
      @tempfile = uploaded_file[:tempfile]
    end

    def filename
      @filename ||= compute_filename
    end

    def spec
      @spec ||= load_gemspec
    end

    def open(&block)
      @tempfile.rewind
      block.call(@tempfile)
    end

    def validate!
      unless spec.name
        raise InvalidGem.new("Empty gem name")
      end
      unless spec.version
        raise InvalidGem.new("Empty gem version")
      end
      true
    end

    private

    def compute_filename
      a = [spec.name, spec.version]
      if spec.platform && spec.platform != 'ruby'
        a << spec.platform
      end
      "#{a.join('-')}.gem"
    end

    def load_gemspec
      Gem::Package.new(@tempfile).spec
    end
  end
end
