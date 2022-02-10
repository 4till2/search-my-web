class String

  def valid_url?
    return false if include?('<script')

    url_regexp = %r{^(http|https)://[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(/.*)?$}ix
    self =~ url_regexp ? true : false
  end

end
