class PiecesController < ApplicationController
  before_action :find_piece, :verify_player_turn, :verify_valid_move

  def update
    @game = @piece.game
    is_captured
    @piece.update_attributes(piece_params.merge(move_number: @piece.move_number + 1))
    king_opp = @game.pieces.where(:type =>"King").where.not(:user_id => @game.turn_user_id)[0]
    if king_opp.check?(king_opp.x_coord, king_opp.y_coord)
      if king_opp.find_threat_and_determine_checkmate(king_opp)
        king_opp.update_winner
        render json: {}, status: 401
      end
    end
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
    (@piece.contains_own_piece?(piece_params[:x_coord].to_i, piece_params[:y_coord].to_i) == false) &&
    (player_moves_own_king_to_check_or_keeps_king_in_check? == false)
    render json: {}, status: 422
  end

  def verify_player_turn
    return if correct_turn? &&
    ((@piece.game.white_player_user_id == current_user.id && @piece.white?) ||
    (@piece.game.black_player_user_id == current_user.id && @piece.black?))
    render json: {}, status: 422
  end

  def correct_turn?
    @piece.game.turn_user_id == current_user.id
  end

  def piece_params
    params.require(:piece).permit(:x_coord, :y_coord)
  end

  def is_captured
    capture_piece = @piece.find_capture_piece(piece_params[:x_coord].to_i, piece_params[:y_coord].to_i)
    if !capture_piece.nil?
      @piece.remove_piece(capture_piece)
    end
  end

  def player_moves_own_king_to_check_or_keeps_king_in_check?
    king = @game.pieces.where(:type =>"King").where(:user_id => @game.turn_user_id)[0]
    if @piece.type == "King"
      if @piece.check?(piece_params[:x_coord].to_i, piece_params[:y_coord].to_i) == true
        return true
      else
        return false
      end
    elsif @piece.type != "King" && king.check?(king.x_coord,king.y_coord)
      return true
    else
      return false
    end
  end

end
