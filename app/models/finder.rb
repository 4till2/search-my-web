class Finder
  SCOPE_OPTIONS = %i[author domain].freeze
  attr_reader :input, :scope

  def initialize(input, scope = nil)
    @input = input
    @scope = scope
  end

  def search
    return unless @input

    pages = Page.search(query).where(scope)

  end

  def query
    clean_input
  end

  def scope
    validate_scope(@scope || scope_db)
  end

  # Add each scope to hash in database format
  # Flags can be repeated and combined as AND or OR
  # Each option is by default chained as an AND condition. NOT and OR are not yet supported
  def scope_db
    { **format_for_db(:author, authors), **format_for_db(:domain, domains) }
  end

  # Will return a regex for extracting a provided scope
  # The expected format is field:[option, option two, ...]
  # field:name == name
  # field:[name1 name2] == name1 name 2
  # @param scopes The scopes as a symbol or array of symbols for the desired scope.
  # @param container Should the regex return the scopes encapsulation or just the values.
  # @return regex
  # @example scope_regex(:author, false) => A regex that will return [[one], [two]] from the string "author:[one,two]"
  # @example scope_regex(:author, true) => A regex that will return [[author:[one,two]], [[one], [two]]] from the string "author:[one,two]"
  def scope_regex(scopes, container = false)
    scopes = scopes.is_a?(Array) ? (scopes && SCOPE_OPTIONS).join('|') : (scopes if SCOPE_OPTIONS.include?(scopes))
    return unless scopes

    /(#{'?:' unless container}(?: ?(?:#{scopes}):\[)([^\])]*)+?(?:\]))/i
  end

  def authors
    extract(:author)
  end

  def domains
    extract(:domain)
  end

  # In Progress
  # def sources
  #   extract(:source)
  # end

  private

  # Get regex, scan input, flatten the results,returns array.. get result, separate according to comma, remove trailing and leading whitespace
  def extract(scopes)
    regex = scope_regex(scopes)
    return unless regex

    @input.scan(regex)&.flatten&.first&.split(',')&.map(&:strip)
  end

  def format_for_db(field, values)
    values ? { "#{field}": values } : {}
  end

  # Removes the scopes from the query string
  def clean_input
    @input.gsub(scope_regex(SCOPE_OPTIONS, true), '')
  end

  # @todo normalize values
  def validate_scope(scope)
    return unless scope

    scope.select { |key| SCOPE_OPTIONS.include?(key) }
  end
end
