require 'pry' # for debugging specs

require 'simplecov'
require 'coveralls'
SimpleCov.profiles.define 'iiif-navigator' do
  add_filter 'pkg'
  add_filter 'spec'
  add_filter 'vendor'
end
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start 'iiif-navigator'

# Ensure there are no ENV configuration values.
FileUtils.mv '.env', '.env_bak', force: true
config_keys = ENV.keys.select {|k| k =~ /ANNO/ }
config_keys.each {|k| ENV.delete k }
require 'iiif_navigator'
IIIF::Navigator.reset
CONFIG = IIIF::Navigator.configuration
CONFIG.cache_enabled = true

require 'rspec'
RSpec.configure do |config|
  # config.fail_fast = true
end

require 'vcr'
cassette_ttl = 7 * 24 * 60 * 60  # 7 days, in seconds
VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.allow_http_connections_when_no_cassette = false
  c.default_cassette_options = {
    :record => :new_episodes,  # :once is default
    :re_record_interval => cassette_ttl
  }
  c.configure_rspec_metadata!
end
