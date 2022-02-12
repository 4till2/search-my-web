class ImportController < ApplicationController

  def new; end

  def do
    urls = params[:urls]
    imp = Importer.new(urls)
    imp.run
    #  do something with the resulting successful and failed indices
    render turbo_stream: turbo_stream.replace('results', partial: 'import/results', locals: { results: imp.complete,
                                                                                              failures: imp.failed,
                                                                                              errors: imp.errors })
  end

end
