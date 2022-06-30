require 'uri'
require 'net/http'
require 'json'

class RoomMessagesController < ApplicationController
  def index
    messages = RoomMessage.where(room_id: params[:room_id])
    render json: messages
  end

  def create
    # NOTE: c'est ici que la magie s'opère
    url = URI('https://demo.piesocket.com/api/publish')
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    room_message = RoomMessage.new(user_id: room_message_params[:user_id], room_id: room_message_params[:room_id],
                                   message: room_message_params[:message])
    if room_message.save
      request = Net::HTTP::Post.new(url)
      request['Content-Type'] = 'application/json'
      request.body = {
        key: 'VCXCEuvhGcBDP7XhiJJUDvR1e1D3eiVjgZ9VRiaV', # NOTE: Demo API Key, get yours at https://piesocket.com
        secret: 'Fvev5c0k59VZ1jRLWuj5URyF5idSdHWm', # NOTE: Demo API Secret, get yours at https://piesocket.com
        channelId: room_message_params[:room_id],
        message: { "message": room_message.message }
      }.to_json
      response = https.request(request)
      puts "response soket #{response.read_body}"
      render json: room_message
    else
      render json: { errors: room_message.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  private

  def room_message_params
    params.permit(:user_id, :room_id, :message)
  end
end
