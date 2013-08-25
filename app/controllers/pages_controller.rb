class PagesController < ApplicationController
  def index
  	@rooms = Room.all
  end
end
