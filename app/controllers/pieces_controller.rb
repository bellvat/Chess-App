class PiecesController < ApplicationController
  before_action :find_piece, :verify_player_turn, :verify_valid_move, :verify_two_players

  def update
    @game = @piece.game
    is_captured
    if params[:piece][:type] == "Queen" || params[:piece][:type] == "Bishop" || params[:piece][:type] == "Knight" || params[:piece][:type] == "Rook"
      @piece.update_attributes(type: params[:piece][:type])
    else  
      @piece.update_attributes(piece_params.merge(move_number: @piece.move_number + 1))
    end

    #Below king_opp mean the opponent's player's king. After the player's turn,
    #we'd like to know if the opponent king is in check, and if in check, does
    #the opponent's king have any way to get out of check (see check_mate in king.rb)
    #if the opponent's king is stuck, the game is over, right now noted by the 401 error
    #will need to do a proper game end

    king_opp = @game.pieces.where(:type =>"King").where.not(:user_id => @game.turn_user_id)[0]
    king_current = @game.pieces.where(:type =>"King").where(:user_id => @game.turn_user_id)[0]
    game_end = false
    if king_opp.check?(king_opp.x_coord, king_opp.y_coord).present?
      if king_opp.find_threat_and_determine_checkmate
        king_opp.update_winner
        king_current.update_loser
        game_end = true
      else
        flash[:notice] = "#{king_opp.name} is in check!" #need to refresh to see
        king_opp.update_attributes(king_check: 1)
      end
    elsif king_opp.stalemate?
      @game.update_attributes(state: "end")
      game_end = true
    end
    if game_end == false && !(@piece.type == "Pawn" && @piece.pawn_promotion?)
      switch_turns
      render json: {}, status: 200
    else
      render json: {}, status: 201
      #somehow will need the code below to pass so we can have a message. Right now below is failing tests and saying the http code is 200 :(
      #render json: {status: "Not modified (standing in for success)", code: 304, message: "Game over!"}
    end
  end

  private

  def verify_two_players
    return if @game.black_player_user_id && @game.white_player_user_id
    render json: {}, status: 422
  end


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
    return if @piece.valid_move?(piece_params[:x_coord].to_i, piece_params[:y_coord].to_i, @piece.id, @piece.white == true) &&
    (@piece.is_obstructed(piece_params[:x_coord].to_i, piece_params[:y_coord].to_i) == false) &&
    (@piece.contains_own_piece?(piece_params[:x_coord].to_i, piece_params[:y_coord].to_i) == false) &&
    (king_not_moved_to_check_or_king_not_kept_in_check? == true) && 
    @piece.pawn_promotion?
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
    params.require(:piece).permit(:x_coord, :y_coord, :captured, :white, :id)
  end

  def is_captured
    capture_piece = @piece.find_capture_piece(piece_params[:x_coord].to_i, piece_params[:y_coord].to_i)
    if !capture_piece.nil?
      @piece.remove_piece(capture_piece)
    end
  end

  def king_not_moved_to_check_or_king_not_kept_in_check?
    #function checks if player is not moving king into a check position
    #and also checking that if king is in check, player must move king out of check,
    #this function restricts any other random move if king is in check.
    king = @game.pieces.where(:type =>"King").where(:user_id => @game.turn_user_id)[0]
    if @piece.type == "King"
      if @piece.check?(piece_params[:x_coord].to_i, piece_params[:y_coord].to_i, @piece.id, @piece.white == true).blank?
        king.update_attributes(king_check: 0)
        return true
      else
        return false
      end
    elsif @piece.type != "King" && king.king_check == 1
      if ([[piece_params[:x_coord].to_i, piece_params[:y_coord].to_i]] & king.check?(king.x_coord, king.y_coord).build_obstruction_array(king.x_coord, king.y_coord)).count == 1 ||
        (@piece.valid_move?(piece_params[:x_coord].to_i, piece_params[:y_coord].to_i, @piece.id, @piece.white == true) == true &&
        king.check?(king.x_coord, king.y_coord).x_coord == piece_params[:x_coord].to_i &&
        king.check?(king.x_coord, king.y_coord).y_coord == piece_params[:y_coord].to_i)
        king.update_attributes(king_check: 0)
        return true
      else
        return false
      end
    else
      return true
    end
  end
end
