class PiecesController < ApplicationController
  before_action :correct_turn?, only: [:update]
  def update
    @piece = Piece.find(params[:id])
    @game = @piece.game
      @piece.update_attributes(piece_params)
      switch_turns
      redirect_to game_path(@game)

  end

  private

  def switch_turns
    if @game.white_player_user_id == @game.turn_user_id
      @game.update_attributes(turn_user_id:@game.black_player_user_id)
    elsif @game.black_player_user_id == @game.turn_user_id
      @game.update_attributes(turn_user_id:@game.white_player_user_id)
    end
  end

  def correct_turn?
    @game.turn_user_id == current_user.id
  end

  def piece_params
    params.require(:piece).permit(:x_coord, :y_coord)
  end
end
