class King < Piece

  def valid_move?(new_x_coord, new_y_coord, id = nil, color = nil)
    x_distance = x_distance(new_x_coord)
    y_distance = y_distance(new_y_coord)

    (x_distance == 1 && y_distance == 0) ||
    (y_distance == 1 && x_distance == 0) ||
    (y_distance == 1 && y_distance == x_distance)
  end

  def check?(x_coord, y_coord, id = nil, color = nil)
    game.pieces.each do | f |
      if f.user_id != self.user_id && f.x_coord != nil
        if f.valid_move?(x_coord, y_coord, id = nil, color = nil) == true && f.is_obstructed(x_coord, y_coord) == false
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

  private

  def any_moves_left?(threat, obstruction_array)
    possible_coords = []
    (1..8).each do |num1|
      (1..8).each do |num2|
        if valid_move?(num1,num2) == true && contains_own_piece?(num1,num2) == false
          possible_coords << [num1, num2]
        end
      end
    end
    return true if (possible_coords - obstruction_array).count >= 1
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
end
