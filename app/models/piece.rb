class Piece < ApplicationRecord
  belongs_to :game
  belongs_to :user, required: false

  #this should be automatically grabbed from the last position of the piece
  def coord_start
  end

  def is_obstructed(x_start, y_start, x_end, y_end)
    y_change = y_start - y_end
    y_change_abs = (y_start - y_end).abs
    x_change = x_start - x_end
    x_change_abs = (x_start - x_end).abs
    obstruction_array = []
    if x_change_abs == 0 # If it's moving vertically
      y_change_abs.times do |i| # 7 times do (0..6).each do
        if y_change > 0
          obstruction_array << [x_start, y_start - (i + 1)]
        elsif y_change < 0
          obstruction_array << [x_start, (y_start + (i + 1))]
        end
      end
    elsif y_change_abs == 0 # If horizontally
      x_change_abs.times do |i| # 7 times do (0..6).each do
        if x_change > 0
          obstruction_array << [x_start - (i + 1), y_start]
        elsif x_change < 0
          obstruction_array << [x_start + (i + 1), y_start]
        end
      end
    elsif y_change_abs == x_change_abs #if diagonally
      y_change_abs.times do |i|
        if x_change > 0 && y_change > 0 # moving upper left
          obstruction_array << [x_start- (i + 1), y_start - (i + 1)]
        elsif x_change > 0 && y_change < 0 #moving lower left
          obstruction_array << [x_start- (i + 1), y_start + (i + 1)]
        elsif x_change < 0 && y_change > 0 # moving upper right
          obstruction_array << [x_start+ (i + 1), y_start - (i + 1)]
        elsif x_change < 0 && y_change < 0 # moving lower right
          obstruction_array << [x_start+ (i + 1), y_start + (i + 1)]
        end
      end
    end

    obstruction_array.each do |square|
      p  game.contains_piece?(square[0], square[1])
    end

  end

  def color
    white? ? 'white' : 'black'
  end

  def image
    image ||= "#{name}.png"
  end
end
