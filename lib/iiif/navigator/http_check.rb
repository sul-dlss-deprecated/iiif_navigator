
# Module mixin for checking HTTP resource availability.
module HTTPCheck

  REDIRECT_CODES = [301, 302, 307]

  # Extract an error message from an exception object
  # @return msg [String] the error message
  def http_error(e)
    msg = e.message
    if e.is_a?(RestClient::Exception)
      msg = e.response.body if e.response.is_a?(RestClient::Response)
    end
    msg
  end

  # Extract the URL from a successful HTTP request
  # @param r [RestClient::Response] a result of a RestClient::Request
  # @param url [String] the URL of the RestClient::Request
  # @return url [String|nil] successful URL (could be a redirect location)
  def http_parse_response(r, url)
    if r.is_a?(RestClient::Response)
      case r.code
      when 200..299 # success
        return r.headers[:content_location] || url
      when 300..399 # redirection
        return r.headers[:location] || url
      end
    end
    nil
  end

  # Utility to check a HTTP resource is available (using GET)
  # @param url [String] the URL to check
  # @return data [Hash] { location: String|nil, error: String|nil }
  def http_get_request(url)
    data = {location: nil, error: nil}
    begin
      loc = url
      r = RestClient.get(url){ |response, request, result, &block|
        if REDIRECT_CODES.include? response.code
          loc = response.headers[:location]
          response.follow_redirection(request, result, &block)
        else
          response.return!(request, result, &block)
        end
      }
      data[:location] = http_parse_response(r, loc)
    rescue RestClient::NotModified => e  # 304
      data[:location] = loc
    rescue => e
      err = http_error(e)
      data[:error] = "RestClient.get failed for #{url}, #{err}"
    end
    data
  end

  # Utility to check a HTTP resource is available (using HEAD)
  # @param url [String] the URL to check
  # @return data [Hash] { location: String|nil, error: String|nil }
  def http_head_request(url)
    data = {location: nil, error: nil}
    begin
      loc = url
      r = RestClient.head(url){ |response, request, result, &block|
        if REDIRECT_CODES.include? response.code
          loc = response.headers[:location]
          response.follow_redirection(request, result, &block)
        else
          response.return!(request, result, &block)
        end
      }
      data[:location] = http_parse_response(r, loc)
    rescue RestClient::NotModified => e
      data[:location] = loc
    rescue => e
      err = http_error(e)
      data[:error] = "RestClient.head failed for #{url}, #{err}"
    end
    data
  end

end
