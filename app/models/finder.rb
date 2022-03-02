class Finder
  attr_reader :input, :scope

  def initialize(input, account: nil, scope: nil)
    @account = account
    @input = Input.new(input)
  end

  # Search by query, with the option to limit the search to a subset of sources, authors, and domains
  # sources are user provided by label and converted to their respective id.
  def search
    return unless @input

    Page.try { |p| @input.sources ? chain_source_options(p) : p }
        .search(@input.query)
        .try { |p| @input.authors || @input.domains ? chain_filter_options(p) : p }
  end

  # Accepts a list of sources with flags and gets all the matching source ids.
  # Capable of per source configuration through per source flags
  def source_ids(sources: nil)
    # return unless @account
    ids = []
    # base case
    sources.each { |source| ids << source_ids(sources: source) } if sources.is_a? Array

    # Merge the system defaults with scope defaults with provided scope flags with source flag (if per_source is true)
    flags = @input.source_flags(sources)

    # pages_only = true; direct page sourcres only
    # deep = false; direct and indirect sources one level deep (page sources, and trusted accounts page sources)
    # deep = true; direct and indirect sources infinitely deep (page sources, and trusted accounts page or account sources ...)
    source_names = sources ? @input.names(sources) : @input.source_names
    puts source_names
    return [] if source_names.empty?

    @account = Account.first
    ids << if flags[:pages]
             @account.source_labels(source_names).pages.ids
           else
             @account.source_labels(source_names).map { |source| source._sources(deep: flags[:deep]) }.map(&:id)
           end
    puts ids
    ids.flatten
  end

  # private

  def format_for_db(field, values)
    values ? { "#{field}": values } : {}
  end

  # @todo normalize values
  def validate_scope(scope)
    return {} unless scope

    scope.select { |key, value| SCOPE_OPTIONS.include?(key) && value.present? }
  end

  def chain_source_options(chain)
    chain.left_joins(:sourcers).where(sourcers: format_for_db(:id, source_ids))
  end

  def chain_filter_options(chain)
    chain.where({
                  **format_for_db(:author, @input.authors),
                  **format_for_db(:domain, @input.domains)
                })
  end

end
