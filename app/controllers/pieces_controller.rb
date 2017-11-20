class PiecesController < ApplicationController
  before_action :find_piece, :verify_player_turn, :verify_valid_move
  def update
    @game = @piece.game
    # SPECIAL CASE FOR WHEN IT'S A KING AND CASTLING
    if @piece.type == "King" && @piece.legal_to_castle?(params[:x_coord].to_i, params[:y_coord].to_i) # Doesn't seem to return true when it should --> to be investigated
      @piece.castle(params[:x_coord].to_i, params[:y_coord].to_i)
    else
      @piece.update_attributes(piece_params) # MAKE REGULAR MOVE
    end
    @piece.update_attributes(move_number: @piece.move_number + 1)
    switch_turns
    render json: {}, status: 200
  end

  private

  def switch_turns
    if @game.white_player_user_id == @game.turn_user_id
      @game.update_attributes(turn_user_id:@game.black_player_user_id)
    elsif @game.black_player_user_id == @game.turn_user_id
      @game.update_attributes(turn_user_id:@game.white_player_user_id)
    end
  end

  def find_piece
    @piece = Piece.find(params[:id])
    @game = @piece.game
  end

  def verify_valid_move
    return if @piece.valid_move?(piece_params[:x_coord].to_i, piece_params[:y_coord].to_i) &&
    (@piece.is_obstructed(piece_params[:x_coord].to_i, piece_params[:y_coord].to_i) == false) &&
    (@piece.contains_own_piece?(piece_params[:x_coord].to_i, piece_params[:y_coord].to_i) == false)
    render json: {}, status: 422
  end

  def verify_player_turn
    return if correct_turn? &&
    ((@game.white_player_user_id == current_user.id && @piece.white?) ||
    (@game.black_player_user_id == current_user.id && @piece.black?))
    render json: {}, status: 422
  end

  def correct_turn?
    @piece.game.turn_user_id == current_user.id
  end

  def piece_params
    params.require(:piece).permit(:x_coord, :y_coord, :captured)
  end

  def is_captured
    capture_piece = @piece.find_capture_piece(piece_params[:x_coord].to_i, piece_params[:y_coord].to_i)
    if !capture_piece.nil?
      @piece.remove_piece(capture_piece)
    end
  end

end
