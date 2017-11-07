class PiecesController < ApplicationController
  def update
    @piece = Piece.find(params[:id])
    @game = @piece.game
    @piece.update_attributes(piece_params)
    redirect_to game_path(@game)

  end

  private

  def correct_turn?
    @game.turn_user_id == current_user.id
  end

  def piece_params
    params.require(:piece).permit(:x_coord, :y_coord)
  end
end
