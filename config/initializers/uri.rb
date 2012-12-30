require 'uri/generic'
require 'pathname'
require 'open-uri'

class Pathname
  def to_uri
    URI::File.for_file(absolutepath.to_s)
  end
end

class String
  def to_uri
    URI.parse(self)
  end
end

module URI
  class Generic
    def to_pathname
      nil
    end

    def to_uri
      self
    end
  end

  def self.from_file(pathname)
    pathname.to_pathname.to_uri
  end

  # Returns an array of URIs
  def self.follow_redirects(url, options={})
    options[:max_redirects] ||= 10
    options[:timeout] ||= 10
    options[:redirect_urls] ||= []
    options[:method] ||= Net::HTTP::Head

    if uri.scheme.nil? && pathname.exist?
      return File.follow_redirects(url, {:paths => options[:max_redirects]})
    elsif options[:redirect_urls].size >= options[:max_redirects]
      return options[:redirect_urls]
    end

    uri = normalize(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.open_timeout = http.read_timeout = options[:timeout]

    if uri.instance_of? URI::HTTPS
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.timeout = options[:timeout]
    end

    request = options[:method].new(path, {"User-Agent" => options[:user_agent]})
    response = http.request(request)

    options[:redirect_urls] << url

    case response
      when Net::HTTPSuccess
        return options[:redirect_urls]
      when Net::HTTPRedirection
        return follow_redirects response['location'], options
      else
        # try GET instead of HEAD
        if options[:method] == Net::HTTP::Get
          response.error!
        else
          options[:method] = Net::HTTP::Get
          follow_redirects url, options
        end
    end
  end
end
