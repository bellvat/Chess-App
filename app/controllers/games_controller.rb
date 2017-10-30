class GamesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

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
    @game = Game.find_by_id(params[:id])
    #Function to update game_piece x and y coordinates. To be changed after we finalize how we grab coordinates
    #from frontend to backend
    @game.select_piece.update_attributes(game_piece_params)

    #This is the turn_user_id switching function. Every time a player updates their
    #move, the turn_user_id will be switched.
    if @game.turn_user_id == @game.white_player.id
      @game.update_attribute(:turn_user_id, @game.black_player.id)
    elsif @game.turn_user_id == @game.black_player.id
      @game.update_attribute(:turn_user_id, @game.white_player.id)
    end
    redirect_to game_path(@game)
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
  end

  private

  def game_params
    params.require(:game).permit(:white_player_user_id, :black_player_user_id, :winner_user_id, :turn_user_id)
  end

  def game_piece_params
    params.require(:game_piece).permit(:x_coord,:y_coord)
  end


end
