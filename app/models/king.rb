class King < Piece

  def valid_move?(new_x_coord, new_y_coord)
   new_x_coord <= x_coord + 1 && new_x_coord >= x_coord - 1 && new_y_coord <= y_coord + 1 && new_y_coord >= y_coord - 1 
  end

end


