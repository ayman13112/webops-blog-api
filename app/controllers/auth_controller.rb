
require Rails.root.join('app/lib/json_web_token')
class AuthController < ApplicationController
  skip_before_action :authorize_request, only: [:signup, :login]

  def signup
    Rails.logger.info "Signup method called"
    user = User.new(user_params)
    if user.save
      token = JsonWebToken.encode(user_id: user.id)
      render json: { token: token, user: user }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      render json: { token: token, user: user }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  private

  def user_params
    params.require(:auth).permit(:name, :email, :password, :image)
  end
end
