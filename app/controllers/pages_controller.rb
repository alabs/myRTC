class PagesController < ApplicationController
  def index
  	@rooms = Room.all
    @room_new = Room.new
  end
end
