class Knight < Piece
  def valid_move?(new_x_coord, new_y_coord)

    return true if new_x_coord == x_coord + 1 && new_y_coord == y_coord + 2
    return true if new_x_coord == x_coord + 2 && new_y_coord == y_coord + 1
    return true if new_x_coord == x_coord - 1 && new_y_coord == y_coord - 2
    return true if new_x_coord == x_coord - 2 && new_y_coord == y_coord - 1
    return true if new_x_coord == x_coord + 1 && new_y_coord == y_coord - 2
    return true if new_x_coord == x_coord + 2 && new_y_coord == y_coord - 1
    return true if new_x_coord == x_coord - 1 && new_y_coord == y_coord + 2
    return true if new_x_coord == x_coord - 2 && new_y_coord == y_coord + 1
  
    return false
  end
end
