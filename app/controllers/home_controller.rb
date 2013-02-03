class HomeController < ApplicationController
  def index
  	@nodes = Host.all
  end
end
