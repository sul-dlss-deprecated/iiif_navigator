require 'requires'

module IIIF
  module Navigator

    AGENT = RDF::URI.parse('https://github.com/sul-dlss/iiif_navigator')

    # configuration at the module level, see
    # http://brandonhilkert.com/blog/ruby-gem-configuration-patterns/

    class << self
      attr_writer :configuration
    end

    def self.configuration
      @configuration ||= Configuration.new
    end

    def self.reset
      @configuration = Configuration.new
    end

    def self.configure
      yield(configuration)
    end

  end

end
