class Finder
  SCOPE_OPTIONS = %i[author domain source].freeze
  attr_reader :input

  def initialize(input, account: nil, scope: nil)
    @account = account
    @input = input
    @scope = validate_scope(scope)
  end

  # Helper method to set and see scopes exclusively.
  def inspect_scope(scope = nil)
    SCOPE_OPTIONS.each { |s| public_send(s.to_s.pluralize) }
    scope.present? ? @scope[scope] : @scope
  end

  # Search by query, with the option to limit the search to a subset of sources, authors, and domains
  # sources are user provided by label and converted to their respective id. 
  def search
    return unless @input

    Page.try { |p| sources ? chain_source_options(p) : p }
        .search(query)
        .try { |p| authors || domains ? chain_filter_options(p) : p }
  end

  def query
    clean_input
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
    @scope[:author] ||= extract(:author)
  end

  def domains
    @scope[:domain] ||= extract(:domain)
  end

  def sources
    @scope[:source] ||= extract(:source)
  end

  def source_ids(sources, flags: { pages: true, deep: false })
    return unless @account

    if flags[:pages]
      @account.source_labels(sources).pages.ids
    else
      @account.source_labels(sources).map { |source| source._sources(deep: flags[:deep]) }.map(&:id)
    end
  end

  private

  # Get regex, scan input, flatten the results,returns array.. get result, separate according to comma, remove trailing and leading whitespace
  # @return array of values
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
    return {} unless scope

    scope.select { |key, value| SCOPE_OPTIONS.include?(key) && value.present? }
  end

  def chain_source_options(chain)
    chain.left_joins(:sourcers).where(sourcers: format_for_db(:id, source_ids(sources)))
  end

  def chain_filter_options(chain)
    chain.where({
                  **format_for_db(:author, authors),
                  **format_for_db(:domain, domains)
                })
  end

end
