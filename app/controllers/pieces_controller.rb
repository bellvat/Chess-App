class PiecesController < ApplicationController
  before_action :find_piece

  def update
    @game = @piece.game
    @piece = Piece.find(params[:id])

    if !correct_turn? && !two_players?
      render :json => { message: "Not your turn", class: "alert alert-warning"}, status: 422
    else
      @piece.can_move(piece_params)
    end

  end

  private


  def correct_turn?
    @piece.game.turn_user_id == current_user.id
  end

  def two_players?
    @game.black_player_user_id && @game.white_player_user_id
  end


  def find_piece
    @piece = Piece.find(params[:id])
    @game = @piece.game
  end

  def verify_player_turn
    return if correct_turn? &&
    ((@piece.game.white_player_user_id == current_user.id && @piece.white?) ||
    (@piece.game.black_player_user_id == current_user.id && @piece.black?))
    respond_to do |format|
      format.json {render :json => { message: "Not yet your turn!", class: "alert alert-warning"}, status: 422}
    end
  end

  def piece_params
    params.require(:piece).permit(:x_coord, :y_coord, :captured, :white, :id)
  end


end
