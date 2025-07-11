class PostsController < ApplicationController
  before_action :authorize_request  # Ensures the user is authenticated
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def create
    post = @current_user.posts.build(post_params)
    if post.save
      DeletePostJob.set(wait: 24.hours).perform_later(post.id)
      render json: post, status: :created
    else
      render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
    posts = Post.includes(:comments).all
    render json: posts.as_json(include: :comments), status: :ok
  end

  def show
    post = Post.includes(:comments).find(params[:id])
    render json: post.as_json(include: :comments), status: :ok
  end

  def update
    post = Post.find(params[:id])

    if post.user_id != @current_user.id
      return render json: { error: "Unauthorized" }, status: :unauthorized
    end

    if post.update(post_params)
      render json: post.as_json(include: :comments), status: :ok
    else
      render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    post = @current_user.posts.find_by(id: params[:id])
    if post
      post.destroy
      render json: { message: 'Post deleted' }
    else
      render json: { error: 'Not authorized or post not found' }, status: :unauthorized
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :tags)
  end

  def record_not_found
    render json: { error: "Post not found" }, status: :not_found
  end
end
