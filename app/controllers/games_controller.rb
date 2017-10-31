class GamesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :join, :forfeit]

  def index
    @unmatched_games = Game.where(:white_player_user_id => nil).where.not(:black_player_user_id => nil).or (Game.where.not(:white_player_user_id => nil).where(:black_player_user_id => nil))
    @started_games = Game.where.not(:white_player_user_id => nil).where.not(:black_player_user_id => nil).where(:winner_user_id => nil)
    @completed_games = Game.where.not(:winner_user_id => nil)
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

  def update

  end
  
  def join
    @game = Game.find_by_id(params[:id])
    # # commented out for testing, don't want to log in and out all the time
    # if @game.users.first == current_user
    #   return render text: "You cannot join your own game, you numpty", status: :forbidden
    # end

    @game.update_attributes(game_params)
    @game.users << current_user
    redirect_to game_path(@game)

  end


  def forfeit
    @game = Game.find_by_id(params[:id])
    @game.update_attributes(game_params)
    redirect_to games_path
  end

  private

  def game_params
    params.require(:game).permit(:white_player_user_id, :black_player_user_id, :winner_user_id, :turn_user_id)
  end
end
