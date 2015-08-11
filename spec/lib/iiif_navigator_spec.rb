require 'spec_helper'

describe IIIF::Navigator do

  describe ".configuration" do
    it "should be a configuration object" do
      expect(described_class.configuration).to be_a_kind_of IIIF::Navigator::Configuration
    end
  end

  describe "#configure" do
    before :each do
      IIIF::Navigator.configure do |config|
        config.debug = true
      end
    end
    it "returns a hash of options" do
      config = IIIF::Navigator.configuration
      expect(config).to be_instance_of IIIF::Navigator::Configuration
      expect(config.debug).to be_truthy
    end
    after :each do
      IIIF::Navigator.reset
    end
  end

  describe ".reset" do
    before :each do
      IIIF::Navigator.configure do |config|
        config.debug = true
      end
    end
    it "resets the configuration" do
      IIIF::Navigator.reset
      config = IIIF::Navigator.configuration
      expect(config).to be_instance_of IIIF::Navigator::Configuration
      expect(config.debug).to be_falsey
    end
    after :each do
      IIIF::Navigator.reset
    end
  end

end

