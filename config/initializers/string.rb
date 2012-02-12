class String
  def strip_prefix prefix
    if start_with?(prefix)
      self[(prefix.size)..-1]
    else
      self
    end
  end

  def ensure_prefix prefix
    if start_with?(prefix)
      self[(prefix.size)..-1]
    else
      self
    end
  end
end
