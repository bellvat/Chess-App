class PiecesController < ApplicationController
  before_action :find_piece, :verify_player_turn, :verify_valid_move, :verify_two_players

  def update
    @game = @piece.game
    is_captured
    if @piece.type == "King" && @piece.legal_to_castle?(piece_params[:x_coord].to_i, piece_params[:y_coord].to_i)
      @piece.castle(params[:x_coord].to_i, params[:y_coord].to_i)
    else
      @piece.update_attributes(piece_params.merge(move_number: @piece.move_number + 1))
    end

    if game_end == false
      switch_turns
      render json: {}, status: 200
    else
      render json: {}, status: 201
      #somehow will need the code below to pass so we can have a message. Right now below is failing tests and saying the http code is 200 :(
      #render json: {status: "Not modified (standing in for success)", code: 304, message: "Game over!"}
    end
  end

  private

  def find_piece
    @piece = Piece.find(params[:id])
    @game = @piece.game
  end

  def piece_params
    params.require(:piece).permit(:x_coord, :y_coord, :captured, :white, :id)
  end

end
