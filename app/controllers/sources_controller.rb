class SourcesController < ApplicationController
  before_action :authenticate_user!

  def index
    @sources = Source.where(account: current_account)
    @results = @sources.map(&:page)
  end

end
