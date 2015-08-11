require "spec_helper"

module IIIF
  module Navigator

    describe Resource, :vcr do

      let(:auth_id){ 'no99010609' }
      let(:auth_url){ "http://id.loc.gov/authorities/names/#{auth_id}" }
      let(:auth) { Resource.new auth_url }

      describe 'initialize' do
        it 'should not raise error for a valid iri' do
          expect{auth}.not_to raise_error
        end
        it 'should raise error for an invalid iri' do
          expect{Resource.new 'This is not a URL'}.to raise_error(ArgumentError)
        end
      end

      describe 'id' do
        it 'should equal the url basename' do
          expect(auth.id).to eq(auth_id)
        end
      end

      describe 'iri' do
        it 'should equal the auth url' do
          expect(auth.iri.to_s).to eq(auth_url)
        end
        it 'should be an instance of Addressable::URI' do
          expect(auth.iri.instance_of? Addressable::URI).to be_truthy
        end
      end


    end
  end
end
