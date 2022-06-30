class UserController < ApplicationController
  def index
    users = User.all
    render json: users
  end

  def search
    user = User.where(username: user_params[:username])
    if user.present?
      render json: user[0]
    else
      render json: { message: 'user not found' }
    end
  end

  def create
    user = User.new(username: user_params[:username])
    if user.save
      render json: { id: user.id, username: user.username }
    else
      render json: { errors: user.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:username)
  end
end
