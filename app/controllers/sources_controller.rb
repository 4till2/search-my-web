class SourcesController < ApplicationController
  before_action :authenticate_user!

  def index
    sources = Source.includes(:sourceable).where(account: current_account, sourceable_type: 'Page')
    @results = sources.map(&:sourceable)
  end

  def import
    urls = params[:urls].split(/\r?\n|\r\n?|,/)
    imp = Importer.new(urls, current_account)
    imp.run
    #  do something with the resulting successful and failed indices
    if imp.complete.present?
      flash[:notice] = "Processing #{'url'.pluralize(imp.complete.count)}. Please refresh soon for the results!"
    end
    redirect_to sources_path
  end

end
