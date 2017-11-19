class King < Piece

  def valid_move?(new_x_coord, new_y_coord)
    x_distance = x_distance(new_x_coord)
    y_distance = y_distance(new_y_coord)

    x_distance == 1 || y_distance == 1
  end


# --- Castling -------

# may only be done if
# Neither the king nor the chosen rook has previously moved.
# There are no pieces between the king and the chosen rook.
# The king is not currently in check.
# The king does not pass through a square that is attacked by an enemy piece (ie. King won't pass through check)
# The king does not end up in check.

  def can_castle?(new_x_coord, new_y_coord)
    return false unless self.move_number == 0 && Rook.move_number == 0    # Neither the king nor the chosen rook has previously moved.
    return false if is_obstructed(new_x_coord, new_y_coord)     # There are no pieces between the king and the chosen rook.
    return false if check?    #King doesn't start, pass through, or end in check
  end

  def castle!   # Make the actual castle move
    return false unless can_castle?
    if queenside?
      update_attributes(x_coord: 3, y_coord: y_coord)
      rook.update_attributes(x_coord: 4, y_coord: y_coord)
    else # kingside
      update_attributes(x_coord: 7, y_coord: y_coord)
      rook.update_attributes(x_coord: 6, y_coord: y_coord)
    end
  end

  def queenside?
      rook.x_coord < x_coord
  end


end


