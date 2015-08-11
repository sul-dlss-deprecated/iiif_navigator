require 'dotenv'
Dotenv.load

require 'pry'
require 'pry-doc'

# Using rest-client with options to enable a client HTTP cache
require 'rest-client'
RestClient.proxy = ENV['http_proxy'] unless ENV['http_proxy'].nil?
RestClient.proxy = ENV['HTTP_PROXY'] unless ENV['HTTP_PROXY'].nil?

require 'addressable/uri'
require 'json'
require 'uuid'

require 'linkeddata'
require_relative 'rdf/vocab/sc.rb'

# Standalone module includes
require_relative 'iiif/navigator/http_check'
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
