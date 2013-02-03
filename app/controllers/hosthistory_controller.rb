class HosthistoryController < ApplicationController
  def index
  	@nodes = Host.all
  end
end
