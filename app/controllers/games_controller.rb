class GamesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :join, :forfeit, :index]

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
    @pieces = @game.pieces
  end

  def update

  end


  def join
    @game = Game.find_by_id(params[:id])
    # # commented out for testing, don't want to log in and out all the time
    # if @game.users.first == current_user
    #   return render text: "You cannot join your own game, you numpty", status: :forbidden
    # end

    #Half of the pieces are created without belonging to anyone, so here we update them to have that attribute
    @pieces = @game.pieces
    @pieces.where(user_id:nil).update_all(user_id: current_user.id)

    @game.update_attributes(game_params)
    @game.users << current_user
    redirect_to game_path(@game)

  end


  def forfeit
    @game = Game.find_by_id(params[:id])
    if current_user.id == @game.white_player_user_id
      @game.update_attributes(winner_user_id: @game.black_player_user_id)
    else
      @game.update_attributes(winner_user_id: @game.white_player_user_id)
    end
    redirect_to games_path
  end


  private

  def game_params
    params.require(:game).permit(:white_player_user_id, :black_player_user_id, :winner_user_id, :turn_user_id, :name)
  end


end
