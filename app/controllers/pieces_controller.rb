class PiecesController < ApplicationController
  def update
    @piece = Piece.find(params[:id])
    @game = @piece.game

    if correct_turn?
      #I think this is where we validate the move
      # if @piece.valid_move?
      @piece.update_attributes(piece_params)
      redirect_to game_path(@game)
    else
      return render text: 'Naughty, naughty. Please wait your turn.', status: :forbidden
    end
  end

  private

  def correct_turn?
    @game.turn_user_id == current_user.id
  end

  def piece_params
    params.require(:piece).permit(:x_coord, :y_coord)
  end
end
