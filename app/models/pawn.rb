class Pawn < Piece

  def valid_move?(new_x_coord, new_y_coord, id = nil, color = nil)
    x_distance = x_distance(new_x_coord)
    y_distance = y_distance(new_y_coord)
# ----- lines 9-12 Diagonal capture -----
# ----- lines 13-20 Vertical opening and subsequent moves valid only if there is no opposition piece/no piece at destination coordinate-------
# ----- Same color piece at destination coordinate is checked in the verify_valid_move in the piece controller -----
    if en_passant?(new_x_coord, new_y_coord)
      return true
    elsif (x_distance == y_distance) && !white? && opposition_piece?(new_x_coord, new_y_coord, id, color)
      new_y_coord == y_coord + 1
    elsif (x_distance == y_distance) && white? && opposition_piece?(new_x_coord, new_y_coord, id, color)
      new_y_coord == y_coord - 1
    elsif y_coord == 2 && black? && !opposition_piece?(new_x_coord, new_y_coord,  id, color)
      x_distance == 0 && (new_y_coord == 3 || new_y_coord == 4)
    elsif y_coord == 7 && white? && !opposition_piece?(new_x_coord, new_y_coord,  id, color)
      x_distance == 0 && (new_y_coord == 6 || new_y_coord == 5)
    elsif !white? && !opposition_piece?(new_x_coord, new_y_coord,  id, color)
      (x_distance == 0) && (new_y_coord == (y_coord + 1))
    elsif white? && !opposition_piece?(new_x_coord, new_y_coord,  id, color)
      (x_distance == 0) && (new_y_coord == (y_coord - 1))
    else
      false
    end
  end

  def en_passant?(new_x_coord, new_y_coord)
    return false unless ((new_y_coord == y_coord + 1 && !white?) || (new_y_coord == y_coord - 1 && white?)) && ((new_x_coord == x_coord + 1) || (new_x_coord == x_coord - 1)) && ((new_y_coord == 3 && white?) || (new_y_coord == 6 && !white?))
    other_piece = game.pieces.where(y_coord: y_coord, x_coord: new_x_coord, type: "Pawn").first
    return false if other_piece.nil? || other_piece.move_number != 1
    return true
   end
end
