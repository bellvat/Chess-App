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
    if valid_move?(threat.x_coord, threat.y_coord) == true && check?(threat.x_coord, threat.y_coord).blank? ||
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

  def legal_to_castle?(new_x_coord, new_y_coord)
    return false unless self.move_number == 0
    return false unless x_distance(new_x_coord) == 2 && y_distance(new_y_coord) == 0
    if new_x_coord > x_coord
      @rook_for_castling = self.game.pieces.where(type: "Rook", user_id: self.user.id, x_coord: 8).first
    else
      @rook_for_castling = self.game.pieces.where(type: "Rook", user_id: self.user.id, x_coord: 1).first
    end
    return false if @rook_for_castling.nil?
    if !@rook_for_castling.nil?
      return false unless @rook_for_castling.move_number == 0
      return false if is_obstructed(@rook_for_castling.x_coord, @rook_for_castling.y_coord)
    end
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
      if f.user_id == self.user_id && f.x_coord != nil && f != self
        if (f.valid_move?(threat.x_coord, threat.y_coord) == true &&
        f.contains_own_piece?(threat.x_coord, threat.y_coord) == false &&
        f.is_obstructed(threat.x_coord, threat.y_coord) == false)
          return true
          break
        elsif !obstruction_array.empty?
          obstruction_array.each do |coord|
            return true if (f.valid_move?(coord[0],coord[1]) == true &&
            f.contains_own_piece?(coord[0],coord[1]) == false &&
            f.is_obstructed(coord[0],coord[1]) == false)
            break
          end
        end
      end
    end
    return false
  end
end
