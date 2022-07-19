class RecipesController < ApplicationController
  before_action :authorize
  rescue_from ActiveRecord::RecordInvalid, with: :render_invalid

  def index
    recpies = Recipe.all
    render json: recpies, status: :ok
  end

  def create
    user = User.find(session[:user_id])
    recipe = user.recipes.create!(recipe_params)
    render json: recipe, status: :created
  end

  private

  def recipe_params
    params.permit(:title, :instructions, :minutes_to_complete)
  end

  def render_invalid(invalid)
    render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
  end

  def authorize
    render json: { errors: ["Not authorized"] }, status: :unauthorized unless session.include? :user_id
  end
end
