class UriTag < Tag
  def for_uri uri
    DirTag.for_file uri if (uri.is_a? File or uri.to_s.starts_with? "/")
    u = URI.parse uri
    find_or_create_by_path u.host
  end
end
