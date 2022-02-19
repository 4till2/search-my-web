# NOT IN USE // WORK IN PROGRESS
# This class is all experimental as of now.
# Will rank individual pages, and accounts according to the networks trust.
class Ranker
  DEFAULT_RANK = 1
  # For each trusting source adjust according to their Person Rank.
  # For each distrusting source adjust according to their Person Rank.
  # For each referring adjust according to its Page Rank.
  # For the pages domain adjust according to the Domain Rank.
  # For the pages author adjust according to their Person Rank.
  #
  def self.do(ranking, scope = nil, ranker = nil)
    puts "Ranking id of: #{ranking.id} from Ranker id: #{ranker&.id}"
    Ranker.new(ranking, @scope, ranker).compute
  end

  attr_reader :rank

  # @param ranking: who are we ranking
  # @param scope: an array of sourcers to rank with. defaults to all
  # @param ranker: IGNORE. whose asking. used in recursive calls as base case
  def initialize(ranking, scope = nil, ranker = nil)
    @ranking = ranking
    @ranker = ranker
    @scope = scope
    @rank = DEFAULT_RANK
    @rankers = []
    @sourcers = Source.includes(account: :sourcers).where(id: @scope.present? ? @scope & @ranking.sourcer_ids : @ranking.sourcer_ids)
    @ranks = []
  end

  def compute
    benchmark do
      comp(@ranking)
    end
    @rank
  end

  # private
  #
  def compute_sourcers_exper
    @ranks = []
    sourcers = Source.includes(account: :sourcers).where(id: @scope.present? ? @scope & @ranking.sourcers : @ranking.sourcers)
    sourcers.each do |s|
      s.rank
    end
  end

  def compute_sourcers_pagerank
    @ranks = []
    sourcers = Source.includes(account: :sourcers.sum(:rank)).where(id: @scope.present? ? @scope & @ranking.sourcer_ids : @ranking.sourcer_ids)

    # sourcers.each_with_index { |sourcer, index| @ranks[index] = sourcer.rank * Ranker.do(sourcer.account) }
    # puts @ranks.join(', ')
    # puts @ranks.sum

    sourcers.each { |s| @rank += (s.rank * (1 / s.account.sources.count) * s.account.sourcers.sum(:rank)) }

  end

  # @return
  # The aggregate of the ranks given by each sourcer * their influence
  # @note
  # - Gets the overlap of the scoped sourcers with the actual sourcers on thing
  # - For each of the sourcers adjusts the total ranking
  # - Base case for recursive ranking is s == @ranker. The sourcer asking for a rank on another (ranker) gets no opinion on the matter.
  # - Recursively calls to get the ranking of the sourcer as a weight for their influence on the current ranking

  # Took  [22.932662 sec]
  # => 31571

  def comp(ranking)
    return 1 if @rankers.include?(ranking)

    puts 'ranking.....'
    puts ranking
    @rankers.push(ranking)
    rank = 1
    @sourcers.each do |s|
      sourcers = Source.includes(account: :sourcers).where(id: @scope.present? ? @scope & @ranking.sourcer_ids : @ranking.sourcer_ids)
      weight = comp(s.account) || 1 # influence of sourcer
      rank = s.rank + weight
    end
    rank
  end

  def compute_sourcers_recurse
    sourcers = @scope.present? ? @scope & @ranking.sourcers : @ranking.sourcers
    sourcers.each do |s|
      return 1 if s == @ranker # RECURSIVE BASE CASE

      weight = Ranker.do(s.account, @scope, @ranking) || 1 # influence of sourcer
      rank = s.rank * weight
      @rank += rank
    end
  end

  def benchmark
    t0 = Time.now
    yield
    t1 = Time.now
    puts format('Took  [%f sec]', (t1 - t0))
  end
end