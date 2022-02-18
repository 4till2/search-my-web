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
  end

  def compute
    benchmark do
      compute_sourcers_pagerank
    end
    @rank
  end

  # private

  # def compute_sourcers_pagerank
  #   @ranks = []
  #   sourcers = @scope.present? ? @scope & @ranking.sourcers : @ranking.sourcers
  #   rankers = sourcers.map { |s| { account: s.account, rank: 1 / s.account.sources.count, sourceables: s.account.sources.sourceable  } }
  #   ranks = rankers.map do |rank|
  #     rank.sourceables.each {|sourceable| @ranks[sourceable][:rank]{sourceable: sourceable, rank: }  }
  #   end
  #   rankers.each do |ranker|
  #     rank = 1 / ranker[:sources_count]
  #     @rank += rank
  #   end
  # end

  # @return
  # The aggregate of the ranks given by each sourcer * their influence
  # @note
  # - Gets the overlap of the scoped sourcers with the actual sourcers on thing
  # - For each of the sourcers adjusts the total ranking
  # - Base case for recursive ranking is s == @ranker. The sourcer asking for a rank on another (ranker) gets no opinion on the matter.
  # - Recursively calls to get the ranking of the sourcer as a weight for their influence on the current ranking

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
    puts format('Took  [%6.2f sec]', (t1 - t0))
  end
end