class ImportController < ApplicationController
  before_action :authenticate_user!

  def new; end

  def do
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
