class Piece < ApplicationRecord
  belongs_to :game
  belongs_to :user, required: false

  #this should be automatically grabbed from the last position of the piece
  def coord_start
  end

  #method currently not used and included directly in is_obstructed
  #couldn't get obstruction array to work with is_obstructed
  def create_obstruction_array_diag_vert (x_start, y_start, x_end, y_end)

    if x_start == x_end # If it's moving vertically
      y_change = y_start - y_end
      y_change_abs = (y_start - y_end).abs
      obstruction_array = []
      y_change_abs.times do |i| # 7 times do (0..6).each do
        if y_change > 0
          obstruction_array << [x_start, y_start - (i + 1)]
        elsif y_change < 0
          obstruction_array << [x_start, (y_start + (i + 1))]
          p obstruction_array
        end
      end
    elsif y_start == y_end
      x_change = x_start - x_end
      x_change_abs = (x_start - x_end).abs
      obstruction_array = []
      x_change_abs.times do |i| # 7 times do (0..6).each do
        if x_change > 0
          obstruction_array << [x_start - (i + 1), y_start]
        elsif x_change < 0
          obstruction_array << [x_start + (i + 1), y_start]
        end
      end
    end
  end

  def is_obstructed(x_start, y_start, x_end, y_end)
    if x_start == x_end # If it's moving vertically
      y_change = y_start - y_end
      y_change_abs = (y_start - y_end).abs
      obstruction_array = []
      y_change_abs.times do |i| # 7 times do (0..6).each do
        if y_change > 0
          obstruction_array << [x_start, y_start - (i + 1)]
        elsif y_change < 0
          obstruction_array << [x_start, (y_start + (i + 1))]
          print obstruction_array
        end
      end
    elsif y_start == y_end
      x_change = x_start - x_end
      x_change_abs = (x_start - x_end).abs
      obstruction_array = []
      x_change_abs.times do |i| # 7 times do (0..6).each do
        if x_change > 0
          obstruction_array << [x_start - (i + 1), y_start]
        elsif x_change < 0
          obstruction_array << [x_start + (i + 1), y_start]
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
