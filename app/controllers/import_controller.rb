class ImportController < ApplicationController

  def new; end

  def do
    urls = params[:urls]
    Importer.process(urls, current_account)
    #  do something with the resulting successful and failed indices
    redirect_to sources_path
  end

end
