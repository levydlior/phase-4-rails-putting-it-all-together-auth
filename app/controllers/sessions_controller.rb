class SessionsController < ApplicationController
  before_action :authorize
  skip_before_action :authorize, only: [:create]

  def create
    user = User.find_by(username: params[:username])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      render josn: user, status: :created
    else
      render json: { error: "Invalid password or username" }, status: :unauthorized
    end
  end

  def destroy
    session.delete :user_id
    head :no_content
  end

  private

  def authorize
    render json: { error: "Not authorized" }, status: :unauthorized unless session.include? :user_id
  end
end
