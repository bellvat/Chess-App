class King < Piece

  def valid_move?(new_x_coord, new_y_coord, id = nil, color = nil)
    x_distance = x_distance(new_x_coord)
    y_distance = y_distance(new_y_coord)

    (x_distance == 1 && y_distance == 0) ||
    (y_distance == 1 && x_distance == 0) ||
    (y_distance == 1 && y_distance == x_distance) ||
    legal_to_castle?(new_x_coord, new_y_coord)
  end

  def check?(x_coord, y_coord, id = nil, color = nil)
    game.pieces.each do | f |
      if f.user_id != self.user_id && f.x_coord != nil
        if f.valid_move?(x_coord, y_coord, id, color) == true && f.is_obstructed(x_coord, y_coord) == false
          return f
          break
        end
      end
    end
    return false
  end

  def find_threat_and_determine_checkmate
    threat = check?(x_coord, y_coord)
    if check_mate?(threat)
      return true
    end
    return false
  end

  def check_mate?(threat)
    obstruction_array = threat.build_obstruction_array(x_coord, y_coord)
    # check if king can capture the threat
    if valid_move?(threat.x_coord, threat.y_coord) == true ||
    # check if any other piece can move to block the king, or capture the threat
      can_block_king?(threat, obstruction_array) == true ||
    # check if king has many moves left
      any_moves_left?(threat, obstruction_array) == true
      return false
    else
      return true
    end
  end

  def stalemate?
    return true if !any_moves_left?
    return false
  end

# PLAN OF ATTACK
# Legal move?
#   - King previously unmoved DONE
#   - King to move 2 spaces DONE
#   - Find appropriate rook DONE
#   - Appropriate rook is unmoved DONE
#   - No pieces in between (is obstructed) DONE
# - Not currently in check DONE
# - In between square not in check DONE

  def legal_to_castle?(new_x_coord, new_y_coord)
    return false unless self.move_number == 0
    return false unless x_distance(new_x_coord) == 2 && y_distance(new_y_coord) == 0
    if new_x_coord > x_coord
      # MAY NEED TO UPDATE SO THAT IF SOMEONE TRIES TO CASTLE WHEN ROOK HAS BEEN MOVED
      @rook_for_castling = self.game.pieces.where(type: "Rook", user_id: self.user.id, x_coord: 8).first
    else
      @rook_for_castling = self.game.pieces.where(type: "Rook", user_id: self.user.id, x_coord: 1).first
    end
    return false if @rook_for_castling.nil?
    if !@rook_for_castling.nil?
      return false unless @rook_for_castling.move_number == 0
      return false if is_obstructed(@rook_for_castling.x_coord, @rook_for_castling.y_coord)
    end
    # RETURN FALSE IF IN CHECK OR MOVES THROUGH OR INTO CHECK **Checked in Pieces Controller
    #return false if self.check?(x_coord, y_coord, id, color)
    #return false if self.check?((x_coord + new_x_coord) / 2, new_y_coord, id, color)
    #return false if self.check?(new_x_coord, new_y_coord, id, color)
    return true
  end

  def castle(new_x_coord, new_y_coord)
    return false unless legal_to_castle?(new_x_coord, new_y_coord)
    self.update_attributes(x_coord: new_x_coord, y_coord: new_y_coord, move_number: self.move_number + 1)
    if new_x_coord == 3
      @rook_for_castling.update_attributes(x_coord: 4, move_number: 1)
    else new_x_coord == 7
      @rook_for_castling.update_attributes(x_coord: 6, move_number: 1)
    end
  end

  private

  def any_moves_left?(threat = nil, obstruction_array = nil)
    possible_coords = []
    king_surrounding = []
    (1..8).each do |num1|
      (1..8).each do |num2|
        if valid_move?(num1,num2) == true && contains_own_piece?(num1,num2) == false && check?(num1, num2).blank?
          possible_coords << [num1, num2]
        end
        if valid_move?(num1,num2) == true && contains_own_piece?(num1,num2)
          king_surrounding << [num1, num2]
        end
      end
    end
    if threat.present?
      return true if (possible_coords - obstruction_array).count >= 1
    elsif move_number == 0 && king_surrounding.count == 5
      return true
    elsif possible_coords.any?
      return true
    else
      return false
    end
  end

  def can_block_king?(threat,obstruction_array)
    game.pieces.each do |f|
      if f.user_id == self.user_id && f.x_coord != nil
        obstruction_array.each do |coord|
          return true if (f.valid_move?(coord[0],coord[1]) == true &&
          f.contains_own_piece?(coord[0],coord[1]) == false &&
          f.is_obstructed(coord[0],coord[1]) == false) ||
          (f.valid_move?(threat.x_coord, threat.y_coord) == true &&
          f.contains_own_piece?(threat.x_coord, threat.y_coord) == false &&
          f.is_obstructed(threat.x_coord, threat.y_coord) == false)
          break
        end
      end
    end
    return false
  end

   def king_not_moved_to_check_or_king_not_kept_in_check?
    #function checks if player is not moving king into a check position
    #and also checking that if king is in check, player must move king out of check,
    #this function restricts any other random move if king is in check.
    if pieces.type == "King" && :user_id == game.turn_user_id
      if pieces.check?(piece_params[:x_coord].to_i, piece_params[:y_coord].to_i, pieces.id, pieces.white == true).blank?
        update_attributes(king_check: 0)
        return true
      else
        return false
      end
    elsif pieces.type != "King" && king_check == 1
      if ([[piece_params[:x_coord].to_i, piece_params[:y_coord].to_i]] & check?(x_coord, y_coord).build_obstruction_array(x_coord, y_coord)).count == 1 ||
        (pieces.valid_move?(piece_params[:x_coord].to_i, piece_params[:y_coord].to_i, pieces.id, pieces.white == true) == true &&
        check?(x_coord, y_coord).x_coord == piece_params[:x_coord].to_i &&
        check?(x_coord, y_coord).y_coord == piece_params[:y_coord].to_i)
        update_attributes(king_check: 0)
        return true
      else
        return false
      end
    else
      return true
    end
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
end
