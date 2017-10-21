class GamesController < ApplicationController
  def index
    @games = Game.all
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.create(game_params)
    redirect_to game_path
  end

  private

  def game_params
    params.require(:game).permit(:white_user_id, :black_user_id)
  end
end
