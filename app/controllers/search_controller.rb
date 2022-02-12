class SearchController < ApplicationController

  def new
    @query = params[:query]
    render 'index'
  end

  def do
    # user = user_signed_in? ? current_user : User.new
    q = params[:query]
    results = Finder.new.search(q)
    recommendations = nil
    render turbo_stream: turbo_stream.replace('results', partial: 'search/results', locals: { results: results, query: q, recommendations: recommendations })
  end
end
