class SourcesController < ApplicationController
  before_action :authenticate_user!

  def index
    @sources = Source.where(account: current_account, sourceable_type: 'Page')
    @results = @sources.map(&:sourceable)
  end

end
