class PiecesController < ApplicationController
  before_action :find_piece, :verify_player_turn, :verify_valid_move, :verify_player_piece
  def update
    @game = @piece.game
    @piece.update_attributes(piece_params)
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
  end

  def verify_valid_move
    return if @piece.valid_move?(piece_params[:x_coord].to_i, piece_params[:y_coord].to_i) &&
    (@piece.is_obstructed(piece_params[:x_coord].to_i, piece_params[:y_coord].to_i) == false) &&
    (@piece.contains_own_piece?(piece_params[:x_coord].to_i, piece_params[:y_coord].to_i) == false)
    render json: {}, status: 422
  end

  def verify_player_turn
    return if correct_turn?
    render json: {}, status: 422
  end

  def correct_turn?
    @piece.game.turn_user_id == current_user.id
  end

  def piece_params
    params.require(:piece).permit(:x_coord, :y_coord)
  end

  def verify_player_piece
    return if @piece.user.nil? || current_user.id = @piece.game.turn_user_id
    render json: {}, status: 422
  end
end
