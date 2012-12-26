require 'digest/sha2'

class String
  def strip_prefix(prefix)
    if start_with?(prefix)
      self[(prefix.size)..-1]
    else
      self
    end
  end

  def ensure_prefix(prefix)
    if start_with?(prefix)
      self[(prefix.size)..-1]
    else
      self
    end
  end

  def sha1
    Digest::SHA1.hexdigest(self)
  end
end
