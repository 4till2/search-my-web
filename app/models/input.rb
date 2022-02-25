class Input
  SCOPE_OPTIONS = %i[author domain source].freeze
  DEFAULT_FLAGS = { all: false,
                    deep: false,
                    pages: true,
                    test: true }.freeze

  SOURCE_FLAGS = { all: false,
                   deep: true,
                   pages: true }.freeze
  # @param scopes and array of scopes to look for
  # scope:{option[option flag]}[scope flag]}
  # => ["scope:{option[option flag], other}[scope flag]", "scope", "option[option flag]", ["scope", "flag"]
  SCOPE_REGEX = ->(scopes) { /((?: ?(#{scopes.join('|')}):\{)([^}]*)+?(?:\}+?)(?:\[(.+?)\])?)/ if scopes&.is_a?(Array) }
  SCOPE_POS = { raw: 0, name: 1, options: 2, flags: 3 }.freeze

  # option[first second]
  # => ["option[first second]", "option", ["first", "second"]]
  OPTIONS_REGEX = /(?:([^ ,]*)(?:(?::\[)([^\]]*)(?:\]))|[^ ,]*)/
  OPTION_POS = { raw: 0, name: 1, flags: 2 }.freeze

  # n number of consecutive spaces NO COMMA
  FLAG_DELIM_REGEX = /(?: +)/
  # n number of consecutive commas with optional spaces
  OPTION_DELIM_REGEX = /(?:( +)?,( +)?+)/

  attr_reader :input, :scope

  def initialize(input)
    @input = input
    @scope = {}
    parse
  end

  def parse
    parse_scopes(SCOPE_OPTIONS)
  end

  def parse_scopes(scopes)
    all_scopes = @input.scan(scope_regex(scopes))
    all_scopes.map do |scope|
      @scope[scope[SCOPE_POS[:name]]] = {
        raw: scope[SCOPE_POS[:raw]],
        flags: parse_flags(scope[SCOPE_POS[:flags]]),
        options: parse_options(scope[SCOPE_POS[:options]])
      }
    end
    @scope
  end

  def parse_options(string)
    options = string.split(OPTION_DELIM_REGEX)
    options.map do |option|
      op = option.match(OPTIONS_REGEX)
      { raw: op[OPTION_POS[:raw]],
        name: op[OPTION_POS[:name]] || op[OPTION_POS[:raw]],
        flags: parse_flags(op[OPTION_POS[:flags]])
      }
    end
  end

  def parse_flags(str)
    return {} unless str

    h = {}
    str.split(FLAG_DELIM_REGEX).each { |s| h[s.to_sym] = true }
    h
  end

  # @param scopes The scopes as a symbol or array of symbols for the desired scope.
  # @return regex to parse provided scopes
  # @example see [SCOPE_REGEX]
  def scope_regex(scopes)
    scopes = scopes.is_a?(Array) ? scopes : [scopes]
    scopes = scopes.map { |s| s if SCOPE_OPTIONS.include?(s) }

    return if scopes.empty?

    SCOPE_REGEX.call(scopes)
  end

  def parsed_field(key)
    @scope[key.to_s] ||= parse_scopes(key)[key.to_s]
  end

  def authors
    parsed_field(:author)
  end

  def domains
    parsed_field(:domain)
  end

  def sources
    parsed_field(:source)
  end

  def names(key)
    return {} unless key
    key[:options].map { |source| source[:name] }
  end

  def source_names
    names(sources)
  end

  def source_flags(source = nil)
    DEFAULT_FLAGS.merge(SOURCE_FLAGS).merge(flags(sources)).try { |p| source ? p.merge(flags(source)) : p }
  end

  def flags(key)
    return {} unless key
    key[:flags]
  end

  def query
    clean_input(@scope.map { |key, val| val[:raw] if val })
  end

  def purge_scopes
    @input = query
  end

  private

  # Removes the raw text or array of text from the input string
  def clean_input(raw)
    return @input if raw.nil?

    regex = raw.is_a?(Array) ? raw.map { |r| Regexp.escape(r) if r }.filter(&:present?).join('|') : Regexp.escape(raw)
    @input.gsub(/#{regex}/, '')
  end

  # @todo normalize values
  def validate_scope(scope)
    return {} unless scope

    scope.select { |key, value| SCOPE_OPTIONS.include?(key) && value.present? }
  end
end
