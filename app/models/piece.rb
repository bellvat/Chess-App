class Piece < ApplicationRecord
  belongs_to :game
  belongs_to :user, required: false

  #def piece_belongs_to_opponent (piece)
  #  return if (@game.white_player_user_id == current_user.id && @piece.black) || (@game.black_player_user_id == current_user.id && @piece.white)
  #  else
  #    render json: {}, status: 422
  #  end
  #end

  def contains_own_piece?(x_end, y_end)
    piece = game.pieces.where("x_coord = ? AND y_coord = ?", x_end, y_end).first
    piece.present? && piece.white == white
  end

  def opposition_piece?(x_end, y_end)
    piece = game.pieces.where("x_coord = ? AND y_coord = ?", x_end, y_end).first
    piece.present? && piece.white != white
  end

  def is_obstructed(x_end, y_end)
    y_change = y_coord - y_end
    x_change = x_coord - x_end

    # Build array squares which piece must move through
    obstruction_array = []
    if x_change.abs == 0 # If it's moving vertically
      (1..(y_change.abs-1)).each do |i|
          obstruction_array << [x_coord, y_coord - (y_change/y_change.abs) * i]
      end
    elsif y_change.abs == 0 # If horizontally
      (1..(x_change.abs-1)).each do |i| # 7 times do (0..6).each do
          obstruction_array << [x_coord - (x_change/x_change.abs) * i, y_coord]
      end
    elsif y_change.abs == x_change.abs #if diagonally
      (1..(y_change.abs-1)).each do |i|
          obstruction_array << [x_coord - (x_change/x_change.abs) * i, y_coord - (y_change/y_change.abs) * i]
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

  #def capturable(capture_piece)
  #  (capture_piece.present? && capture_piece.color != color)
  #end

  def find_capture_piece(x_end, y_end)
    game.pieces.find_by(x_coord: x_end, y_coord: y_end)
  end

  #def move_to_capture_piece_and_capture(dead_piece, x_end, y_end)
  #  update_attributes(x_coord: x_end, y_coord: y_end)
  #  remove_piece(dead_piece)
  #end

  #def capture(capture_piece)
  #  move_to_empty_square(capture_piece.x_coord, capture_piece.y_coord)
#    remove_piece(capture_piece)
  #end

  def remove_piece(dead_piece)
    dead_piece.update_attributes(x_coord: nil, y_coord: nil) ##Should we have a piece status to add to db? Like captured/in play? This would be helpful for stats also
  end

  #def move_to_empty_square(x_end, y_end)
  #  update_attributes(x_coord: x_end, y_coord: y_end)
  #end

end
