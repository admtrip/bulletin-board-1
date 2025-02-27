class BoardsController < ApplicationController
  def index
    @list_of_boards = Board.order(created_at: :desc)
    render({ template: "boards/index" })
  end

  def show
    the_id = params.fetch("path_id")
    @the_board = Board.find(the_id)

    posts_for_board = Post.where(board_id: @the_board.id)
    current_date = Date.today
    @posts_active = posts_for_board.where("expires_on >= ?", current_date)
    @posts_expired = posts_for_board.where("expires_on < ?", current_date)

    render({ template: "boards/show" })
  end

  def create
    the_board = Board.new
    the_board.name = params.fetch("query_name")

    if the_board.valid?
      the_board.save
      redirect_to("/boards", notice: "Board created successfully.")
    else
      redirect_to("/boards", alert: the_board.errors.full_messages.to_sentence)
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_board = Board.find(the_id)
    the_board.name = params.fetch("query_name")

    if the_board.valid?
      the_board.save
      redirect_to("/boards/#{the_board.id}", notice: "Board updated successfully.")
    else
      redirect_to("/boards/#{the_board.id}", alert: the_board.errors.full_messages.to_sentence)
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_board = Board.find(the_id)

    the_board.destroy
    redirect_to("/boards", notice: "Board deleted successfully.")
  end
end
