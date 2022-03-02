class SearchController < ApplicationController

  def index
    @query = params[:query]
  end

  def do
    # user = user_signed_in? ? current_user : User.new
    query = params[:query]
    preload = params[:preload] == 'true'
    if query.present?
      pagy, results = pagy(Finder.new(query, account:current_account).search, items: params[:limit]&.to_i&.positive?)
    elsif preload
      pagy, results = pagy(Finder.new(query, account:current_account).search, items: params[:limit]&.to_i&.positive? || 10)
    end

    # Preload with sources if preload set to true and query is empty
    render turbo_stream: turbo_stream.replace('results', partial: 'search/results', locals: { results: results,
                                                                                              pagy: pagy,
                                                                                              query: query })
  end
end
