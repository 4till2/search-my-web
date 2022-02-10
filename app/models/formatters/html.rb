module Formatters

  class Html
    def self.clean_text(*args)
      new._clean_text(*args)
    end

    def _clean_text(text, length = nil)
      text = Loofah.fragment(text)
                   .scrub!(:prune)
                   .to_text(encode_special_chars: false)
                   .gsub(/\s+/, ' ')
                   .squish

      text = text.truncate(length, separator: ' ', omission: '') if length

      text
    end
  end
end
