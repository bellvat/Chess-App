class Piece < ApplicationRecord
  belongs_to :game
  belongs_to :user, required: false


  def piece_move
    capture_piece = find_capture_piece(x_end, y_end)
    if capture_piece.nil?
      move_to_empty_square(x_end, y_end)
    return false if capture_piece !capturable
    else
      capture(capture_piece)
      move_to_capture_piece_and_capture
    end
  end

  def contains_own_piece?(x_end, y_end)
    piece = game.pieces.where("x_coord = ? AND y_coord = ?", x_end, y_end).first
    piece.present? && piece.white? == white?
  end

  def is_obstructed(x_end, y_end)
    y_change = y_coord - y_end
    x_change = x_coord - x_end

    # Build array squares which piece must move through
    obstruction_array = []
    if x_change.abs == 0 # If it's moving vertically
      y_change.abs.times do |i|
          obstruction_array << [x_coord, y_coord - (y_change/y_change.abs) * (i + 1)]
      end
    elsif y_change.abs == 0 # If horizontally
      x_change.abs.times do |i| # 7 times do (0..6).each do
          obstruction_array << [x_coord - (x_change/x_change.abs) * (i + 1), y_coord]
      end
    elsif y_change.abs == x_change.abs #if diagonally
      y_change.abs.times do |i|
          obstruction_array << [x_coord - (x_change/x_change.abs) * (i + 1), y_coord - (y_change/y_change.abs) * (i + 1)]
      end
    end

    # Check if end square contains own piece and if any of in between squares have a piece of any colour in
    obstruction_array.any?{|square| game.contains_piece?(square[0], square[1]) == true}
  end

  def color
    white? ? 'white' : 'black'
  end

  def white?
    white
  end

  def black?
    !white
  end

  def image
    image ||= "#{name}.png"
  end

  # determines horizontal distance travelled by piece
  def x_distance(new_x_coord)
    x_distance = (new_x_coord - x_coord).abs
  end

  # determines vertical distance travelled by piece
  def y_distance(new_y_coord)
    y_distance = (new_y_coord - y_coord).abs
  end

  # returns true if piece is moving from bottom to top
  def up?(new_y_coord)
    (y_coord - new_y_coord) > 0
  end

  # returns true if piece is moving from top to bottom
  def down?(new_y_coord)
    (y_coord - new_y_coord) < 0
  end

  def diagonal?(x_distance, y_distance)
    x_distance == y_distance
  end

  def capturable(capture_piece)
    (capture_piece.present? && capture_piece.color != color) 
  end

  def find_capture_piece(x_end, y_end)
    game.pieces.find_by(x_coord: x_end, y_coord: y_end)
  end

  def move_to_capture_piece_and_capture(dead_piece, x_end, y_end)
    update_attributes(x_coord: x_end, y_coord: y_end)
    remove_piece(dead_piece)
  end

  def capture(capture_piece)
    move_to_empty_square(capture_piece.x_coord, capture_piece.y_coord)
    remove_piece(capture_piece)
  end

  def remove_piece(dead_piece)
    dead_piece.update_attributes(is_on_board?: false, row_coordinate: -1, column_coordinate: -1)
  end

  def move_to_empty_square(x_end, y_end)
    update_attributes(x_coord: x_end, y_coord: y_end)
  end

end