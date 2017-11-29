class Move < ApplicationRecord

    def notation
     @black = black_player_user_id
     @white = white_player_user_id
 
     x = { 1 => "a", 2 => "b", 3 => "c", 4 => "d", 5 => "e", 6 => "f", 7 => "g", 8 => "h" }
     y = { 1 => "8", 2 => "7", 3 => "6", 4 => "5", 5 => "4", 6 => "3", 7 => "2", 8 => "1" }
     piece = { "King" => "K", "Queen" => "Q", "Bishop" => "B", "Knight" => "N", "Rook" => "R", "Pawn" => " " }
 
     @location = "#{piece}" + "#{x}" + "#{y}"
 
     puts "#{location.white} / #{location.black}"
 
   end
end
