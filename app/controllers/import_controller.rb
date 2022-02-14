class ImportController < ApplicationController

  def new; end

  def do
    urls = params[:urls]
    imp = Importer.new(urls)
    imp.run
    pages = imp.pages
    failed = imp.failed
    errors = imp.errors
    pages.each { |p| Source.create(account: current_account, page: p) }
    #  do something with the resulting successful and failed indices
    render turbo_stream: turbo_stream.replace('results', partial: 'import/results', locals: { results: pages,
                                                                                              failures: failed,
                                                                                              errors: errors })
  end

end
