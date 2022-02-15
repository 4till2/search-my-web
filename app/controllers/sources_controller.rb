class SourcesController < ApplicationController

  def index
    @sources = Source.where(account: current_account)
  end

end
