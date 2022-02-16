class SearchController < ApplicationController

  def index
    @query = params[:query]
  end

  def do
    # user = user_signed_in? ? current_user : User.new
    query = params[:query]
    preload = params[:preload] == 'true'
    results = Finder.new.search(query, current_account) if query
    # Preload with sources if preload set to true and query is empty
    results ||= Source.where(account: current_account).map(&:page) if preload.present? && (query.nil? || query.empty?)

    render turbo_stream: turbo_stream.replace('results', partial: 'search/results', locals: { results: results,
                                                                                              query: query })
  end
end
