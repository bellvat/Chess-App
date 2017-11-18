class King < Piece

  def valid_move?(new_x_coord, new_y_coord)
    x_distance = x_distance(new_x_coord)
    y_distance = y_distance(new_y_coord)

    (x_distance == 1 && y_distance == 0) ||
    (y_distance == 1 && x_distance == 0) ||
    (y_distance == 1 && y_distance == x_distance)
  end

  def check?(x_coord, y_coord)
    game.pieces.each do | f |
      if f.user_id != self.user_id && f.x_coord != nil
        if f.valid_move?(x_coord, y_coord) == true && f.is_obstructed(x_coord, y_coord) == false
          return true
        end
      end
    end
    return false
  end

  def find_threat_and_determine_checkmate(king)
    threat = find_threat
    if check_mate?(king,threat)
      return true
    end
    return false
  end

  def check_mate?(king, threat)
    obstruction_array = threat.build_obstruction_array(king.x_coord, king.y_coord)
    # check if king can capture the threat
    if king.valid_move?(threat.x_coord, threat.y_coord) == true ||
    # check if any other piece can move to block the king
      threat.type != "Knight" && can_block_king?(king,threat,obstruction_array) == true ||
    # check if king has many moves left
      any_moves_left?(king,threat,obstruction_array) == true
      return false
    else
      return true
    end
  end

  private

  def find_threat
    threat_found = false
    while threat_found != true
      game.pieces.each do | f |
        if f.user_id != game.turn_user_id && f.x_coord != nil
          if f.valid_move?(x_coord, y_coord) && f.is_obstructed(x_coord,y_coord) == false
            return f
            threat_found = true
          end
        end
      end
      threat_found
    end
  end

  def any_moves_left?(king,threat,obstruction_array)
    possible_coords = []
    (1..8).each do |num1|
      (1..8).each do |num2|
        if king.valid_move?(num1,num2) == true && king.contains_own_piece?(num1,num2) == false
          possible_coords << [num1, num2]
        end
      end
    end
    return true if (possible_coords - obstruction_array).count >= 1
  end

  def can_block_king?(king,threat,obstruction_array)
    game.pieces.each do |f|
      if f.user_id == game.turn_user_id && f.x_coord != nil
        obstruction_array.each do |coord|
          return true if f.valid_move?(coord[0],coord[1]) == true &&
          f.contains_own_piece?(coord[0],coord[1]) == false &&
          f.is_obstructed(coord[0],coord[1]) == false
          break
        end
      end
    end
    return false
  end
end
