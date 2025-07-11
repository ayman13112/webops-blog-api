class CommentsController < ApplicationController
  before_action :authorize_request
  before_action :set_post
  before_action :set_comment, only: [:update, :destroy]

  def index
    comments = @post.comments
    render json: comments, status: :ok
  end

    def show
        comment = @post.comments.find_by(id: params[:id])
        if comment
            render json: comment, status: :ok
        else
            render json: { error: "Comment not found" }, status: :not_found
        end
    end


    def create
        comment = @post.comments.new(comment_params)
        comment.user = @current_user

        if comment.save
            render json: comment.as_json(include: { user: { only: [:id, :email] } }), status: :created
        else
            render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
        end
    end

  def update
    if @comment.user_id != @current_user.id
      render json: { error: "Unauthorized" }, status: :unauthorized
    elsif @comment.update(comment_params)
      render json: @comment, status: :ok
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @comment.user_id != @current_user.id
      render json: { error: 'Unauthorized' }, status: :unauthorized
    else
      @comment.destroy
      render json: { message: 'Comment deleted' }, status: :ok
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_post
    @post = Post.find_by(id: params[:post_id])
    unless @post
      render json: { error: "Post not found" }, status: :not_found
    end
  end

  def set_comment
    @comment = @post.comments.find_by(id: params[:id])
    unless @comment
      render json: { error: "Comment not found" }, status: :not_found
    end
  end
end
