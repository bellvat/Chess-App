class GamesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def index
    @unmatched_games = Game.where("(state = ?)", "Unmatched")
    @started_games = Game.where("(state = ?)", "Started")
    @completed_games = Game.where("(state = ?)", "Complete")
  end

  def new
    @game = Game.new
  end

  def create
    @game = current_user.games.create(game_params)
    redirect_to game_path(@game)
  end

  def show
    @game = Game.find_by_id(params[:id])
  end

  # THIS COULD PROBABLY BECOME A "JOIN_GAME" method as it's separate to everything else
  def update
    @game = Game.find_by_id(params[:id])
    # # commented out for testing, don't want to log in and out all the time
    # if @game.users.first == current_user
    #   return render text: "You cannot join your own game, you numpty", status: :forbidden
    # end

    @game.update_attributes(game_params)
    @game.users << current_user
    redirect_to game_path(@game)

  end

  private

  def game_params
    params.require(:game).permit(:state,:white_player_user_id, :black_player_user_id, :winner_user_id, :turn_user_id)
  end
end
