class SearchController < ApplicationController

  def index
    @query = params[:query]
  end

  def do
    # user = user_signed_in? ? current_user : User.new
    query = params[:query]
    paginate = { offset: params[:offset]&.to_i, limit: params[:limit]&.to_i, page: [params[:page]&.to_i] }
    preload = params[:preload] == 'true'
    finder = Finder.new(query, account: current_account)
    nav, results = finder.search(paginate) if query.present? || preload
    # Preload with sources if preload set to true and query is empty
    render turbo_stream: turbo_stream.replace('results', partial: 'search/results', locals: { results: results,
                                                                                              nav: nav,
                                                                                              query: query })
  end
end

