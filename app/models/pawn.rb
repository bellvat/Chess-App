class Pawn < Piece

  def valid_move?(new_x_coord, new_y_coord)
    x_distance = x_distance(new_x_coord)
    y_distance = y_distance(new_y_coord)

# ----- Opening move -----
    if y_coord == 2 && black?
      x_distance == 0 && (new_y_coord == 3 || new_y_coord == 4)
    elsif y_coord == 7 && white?
      x_distance == 0 && (new_y_coord == 6 || new_y_coord == 5)

# ----- Otherwise -------
    else
      if black?
        (x_distance == 0) && (new_y_coord == (y_coord + 1))
      elsif white? 
        (x_distance == 0) && (new_y_coord == (y_coord - 1))
      end
    end
  end

  def en_passant?(new_x_coord, new_y_coord)
    # the capturing pawn must be on its fifth rank;
    if piece.type == "Pawn" && (y_coord == 5 && black? || y_coord == 4 && white?)
    # the captured pawn must be on an adjacent file
    && piece.type == "Pawn" && (y_coord == 5 && white? || y_coord == 4 && black?) && (x_coord = x_coord + 1 || x_coord = x_coord - 1)
    # and must have just moved two squares in a single move (i.e. a double-step move);
    && move_number == 1 
    # the capture can only be made on the move immediately after the opposing pawn makes the double-step move, otherwise the right to capture it en passant is lost.
    # op can move sideways 1 to capture

  
  end
end


