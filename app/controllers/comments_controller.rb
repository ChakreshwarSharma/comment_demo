class CommentsController < ApplicationController
  before_action  :authenticate_user!
  before_action  :find_article

  # HTTP POST
  def save_new_comment
    # @article = Article.find(params[:id])
    @comment = Comment.build_from( @article, current_user.id, params[:comment] )
    @comment.save
    render json: {success: true}
  end

  # Http GET
  def new
    @comment = Comment.new
    render :partial => "comment"
  end

  # HTTP POST
  def reply_comment
    parent_id = params[:parent_id]
    @comment = Comment.build_from( @article, current_user.id, params[:comment] )
    # @comment.parent_id= parent_id
    @comment.save
    @comment.move_to_child_of(parent_id)
    @comment.save
    render json: {success: true}
  end

protected
  def find_article
    @article = Article.find(params[:id])
  end
end
