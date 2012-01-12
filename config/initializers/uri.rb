module URI

  def self.normalize uri
    uri = URI.parse(uri)
    uri.path = "/" if path.blank? && uri.scheme
  end

  # Returns an array of URIs
  def self.follow_redirects(url, options={})
    options[:max_redirects] ||= 10
    options[:timeout] ||= 10
    options[:redirect_urls] ||= []
    options[:method] ||= Net::HTTP::Head

    return File.follow_redirects(url, {:paths => options[:max_redirects]}) if uri.scheme.nil? && File.exists?(uri.path)

    return options[:redirect_urls] if options[:max_redirects] <= options[:redirect_urls].size

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

