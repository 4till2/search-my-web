class String

  def valid_url?
    bad_string_regexp = /(<script| |\n)/
    good_url_regexp = %r{^(http|https)://[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(/.*)?$}ix
    self !~ bad_string_regexp && self =~ good_url_regexp ? true : false
  end
end
