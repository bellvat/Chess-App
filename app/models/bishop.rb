class Bishop < Piece

  def valid_move?(new_x_coord, new_y_coord, id = nil, color = nil)
    x_distance = x_distance(new_x_coord)
    y_distance = y_distance(new_y_coord)

    (x_distance >= 1 && y_distance >= 1) && diagonal?(x_distance, y_distance)
  end
end
