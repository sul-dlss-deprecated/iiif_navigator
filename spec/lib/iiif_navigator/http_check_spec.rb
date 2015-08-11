require 'spec_helper'

RSpec.shared_examples "http_checks" do |http_method|

  # create a dummy Class to include the HTTPCheck methods.
  let(:dummy_class) { Class.new.extend(HTTPCheck) }

  # HTTP test pages available at https://jigsaw.w3.org/HTTP/
  let(:url_200) { 'http://www.example.com' }
  let(:url_300) { 'https://jigsaw.w3.org/HTTP/300/Overview.html' }
  let(:url_301) { 'https://jigsaw.w3.org/HTTP/300/301.html' }
  let(:url_302) { 'https://jigsaw.w3.org/HTTP/300/302.html' }
  let(:url_303) { 'https://jigsaw.w3.org/HTTP/300/303_ok.html' }
  let(:url_307) { 'https://jigsaw.w3.org/HTTP/300/307.html' }
  let(:url_404) { 'http://www.google.com/missing.html' }
  let(:url_406) { 'https://jigsaw.w3.org/HTTP/negbad' }
  let(:url_fail){ 'http://example_fails.com' }

  def request_success(method, url)
    case method
    when :head
      data = dummy_class.http_head_request(url)
    when :get
      data = dummy_class.http_get_request(url)
    end
    expect(data[:location]).to match(/\A#{URI::regexp}\z/)
    expect(data[:error]).to be_nil
    data
  end

  def request_failure(method, url)
    case method
    when :head
      data = dummy_class.http_head_request(url)
      err = "RestClient.head failed for #{url}"
    when :get
      data = dummy_class.http_get_request(url)
      err = "RestClient.get failed for #{url}"
    end
    expect(data[:location]).to be_nil
    expect(data[:error]).to be_instance_of(String)
    expect(data[:error]).to include(err)
  end

  it 'returns an iri for a valid URL' do
    data = request_success(http_method, url_200)
    expect(data[:location]).to eql(url_200)
  end

  it 'returns an iri after following 301 redirect' do
    data = request_success(http_method, url_301)
    expect(data[:location]).to eql(url_300)
  end

  it 'returns an iri after following 302 redirect' do
    data = request_success(http_method, url_302)
    expect(data[:location]).to eql(url_300)
  end

  # it 'returns an iri after following 303 redirect' do
  #   data = request_success(http_method, url_303)
  #   expect(data[:location]).to eql(url_300)
  # end

  it 'returns an iri after following 307 redirect' do
    data = request_success(http_method, url_307)
    expect(data[:location]).to eql(url_300)
  end

  it 'returns nil and error message for a non-existent domain' do
    request_failure(http_method, 'http://example_fails.com')
  end

  it 'returns nil and error message for a 404' do
    request_failure(http_method, url_404)
  end

  it 'returns nil and error message for a 406: Not Acceptable' do
    request_failure(http_method, url_406)
  end

end


describe HTTPCheck, :vcr do

  describe 'http_head_request' do
    it_behaves_like 'http_checks', :head
  end

  describe 'http_get_request' do
    it_behaves_like 'http_checks', :get
  end

end
