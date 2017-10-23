class GamesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def index
    @games = Game.all
  end

  def new
    @game = Game.new
  end

  def create
    current_user.games.create(game_params)
    redirect_to game_path
  end

  private

  def game_params
    params.require(:game).permit(:state,:white_user_id, :black_user_id, :winner_user_id, :turn_user_id)
  end
end
