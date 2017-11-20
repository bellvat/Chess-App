class King < Piece

  def valid_move?(new_x_coord, new_y_coord)
    x_distance = x_distance(new_x_coord)
    y_distance = y_distance(new_y_coord)
    (x_distance == 1 || y_distance == 1) || legal_to_castle?(new_x_coord, new_y_coord)
  end

# may only be done if
# Neither the king nor the chosen rook has previously moved.
# There are no pieces between the king and the chosen rook.
# The king is not currently in check.
# The king does not pass through a square that is attacked by an enemy piece (ie. King won't pass through check)
# The king does not end up in check.

# PLAN OF ATTACK
# Legal move?
#   - King previously unmoved DONE
#   - King to move 2 spaces DONE
#   - Find appropriate rook DONE
#   - Appropriate rook is unmoved DONE
#   - No pieces in between (is obstructed) DONE
# - Not currently in check TBD
# - In between square not in check TBD

# Do the move

  def legal_to_castle?(new_x_coord, new_y_coord)
    return false unless self.move_number == 0
    return false unless x_distance(new_x_coord) == 2 && y_distance(new_y_coord) == 0

    if new_x_coord > x_coord
      @rook_for_castling = self.game.pieces.where(type: "Rook", user_id: self.user.id, x_coord: 8).first
    else
      @rook_for_castling = self.game.pieces.where(type: "Rook", user_id: self.user.id, x_coord: 1).first
    end

    return false unless @rook_for_castling.move_number == 0
    return true unless is_obstructed(@rook_for_castling.x_coord, @rook_for_castling.y_coord)
    # CHECK NOT CURRENTLY IN CHECK (Using methods in as-yet-unpulled-request)
    return true
  end

  def castle(new_x_coord, new_y_coord)
    return false unless legal_to_castle?(new_x_coord, new_y_coord)
    self.update_attributes(x_coord: new_x_coord, y_coord: new_y_coord)
    if new_x_coord == 3
      @rook_for_castling.update_attributes(x_coord: 4)
    else new_x_coord == 7
      @rook_for_castling.update_attributes(x_coord: 6)
    end
  end
end


