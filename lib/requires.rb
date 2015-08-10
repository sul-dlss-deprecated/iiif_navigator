require 'dotenv'
Dotenv.load

require 'pry'
require 'pry-doc'

# Using rest-client with options to enable
# a client HTTP cache
require 'rest-client'
RestClient.proxy = ENV['http_proxy'] unless ENV['http_proxy'].nil?
RestClient.proxy = ENV['HTTP_PROXY'] unless ENV['HTTP_PROXY'].nil?
if ENV['RACK_CACHE_ENABLED'].to_s.upcase == 'TRUE'
  require 'restclient/components'
  require 'rack/cache'
  # RestClient.enable Rack::CommonLogger
  RestClient.enable Rack::CommonLogger, STDOUT
  # Enable the HTTP cache to store meta and entity data according
  # to the env config values or the defaults given here.  See
  # http://rtomayko.github.io/rack-cache/configuration for available options.
  metastore = ENV['RACK_CACHE_METASTORE'] || 'file:tmp/cache/meta'
  entitystore = ENV['RACK_CACHE_ENTITYSTORE'] || 'file:tmp/cache/body'
  require 'dalli' if ((metastore =~ /memcache/) || (entitystore =~ /memcache/))
  verbose = ENV['RACK_CACHE_VERBOSE'].to_s.upcase == 'TRUE' || false
  RestClient.enable Rack::Cache,
    :metastore => metastore, :entitystore => entitystore, :verbose => verbose
  # Prime the HTTP cache with some common json-ld contexts used for
  # IIIF and open annotations.
  contexts = [
    'http://iiif.io/api/image/1/context.json',
    'http://iiif.io/api/image/2/context.json',
    'http://iiif.io/api/presentation/1/context.json',
    'http://iiif.io/api/presentation/2/context.json',
    'http://www.shared-canvas.org/ns/context.json'
  ]
  contexts.each {|c| RestClient.get c }
end

require 'addressable/uri'
require 'json'
require 'uuid'

require 'linkeddata'
require_relative 'rdf/vocab/sc.rb'

# OpenAnnotationHarvest module (standalone module for includes)
require_relative 'iiif/navigator/open_annotation_harvest'

# iiif_navigator module
require_relative 'iiif/navigator/version'
require_relative 'iiif/navigator/configuration'
require_relative 'iiif/navigator/resource'
require_relative 'iiif/navigator/manifest'
require_relative 'iiif/navigator/annotation_list'
require_relative 'iiif/navigator/annotation_tracker'
require_relative 'iiif/navigator/iiif_collection'
require_relative 'iiif/navigator/iiif_manifest'
require_relative 'iiif/navigator/iiif_annotation_list'
require_relative 'iiif/navigator/shared_canvas_manifest'
require_relative 'iiif/navigator/shared_canvas_annotation_list'
require_relative 'iiif/navigator/open_annotation'
require_relative 'iiif/navigator/iiif_navigator'
