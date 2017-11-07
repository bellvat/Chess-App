class Piece < ApplicationRecord
  belongs_to :game
  belongs_to :user, required: false

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
    contains_own_piece?(x_end, y_end) && obstruction_array.any?{|square| game.contains_piece?(square[0], square[1]) == true}

  end

  def color
    white? ? 'white' : 'black'
  end

  def image
    image ||= "#{name}.png"
  end

  def x_distance(new_x_coord)
    (new_x_coord - x_coord).abs
  end

  def y_distance(new_y_coord)
    (new_y_coord - y_coord).abs
  end

end
