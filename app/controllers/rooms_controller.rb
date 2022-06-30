class RoomsController < ApplicationController
  def index
    rooms = Room.all
    render json: rooms
  end

  def create
    room = Room.new(name: room_params[:name])
    if room.save
      render json: { id: room.id, name: room.name }
    else
      render json: { errors: room.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  private

  def room_params
    params.permit(:name)
  end
end
