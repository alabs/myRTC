class Api::RoomsController < Api::BaseController

  before_action :set_room, only: [:show, :destroy]

  # GET /api/rooms
  def index
    respond_with :api, Room.order(created_at: :desc)
  end
 
  # GET /api/rooms/1
  def show
    respond_with :api, @room
  end
 
  # POST /api/rooms
  def create
    respond_with :api, Room.create
  end
 
  # DELETE /api/rooms/1
  def destroy
    respond_with :api, @room.destroy
  end

  private
  
  # Use callbacks to share common setup or constraints between actions.
  def set_room
    @room = Room.find_by_name(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  #def feed_params
  #  params.require(:feed).permit()
  #end
end
