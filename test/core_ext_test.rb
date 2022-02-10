require 'test_helper'

class CoreExtTest < ActiveSupport::TestCase
  def test_string_valid_url
    assert_not 'http://ruby3arabi'.valid_url?
    assert_not 'http://http://ruby3arabi.com'.valid_url?
    assert_not 'http://'.valid_url?
    assert_not 'http://test.com\n<script src=\"nasty.js\">'.valid_url?

    assert 'http://example.com'.valid_url?
    assert 'http://ruby3arabi.com'.valid_url?
    assert 'http://www.ruby3arabi.com'.valid_url?
    assert 'https://www.ruby3arabi.com/article/1'.valid_url?
    assert 'https://www.ruby3arabi.com/websites/58e212ff6d275e4bf9000000?locale=en'.valid_url?
  end


  def test_string_to_stem_words
    assert_equal %w[squawk hello world], 'the squawk! Hello   World'.as_word_stems
  end

end