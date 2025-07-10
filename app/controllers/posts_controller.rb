class PostsController < ApplicationController
  before_action :authorize_request  # Ensures the user is authenticated

  # POST /posts
  def create
    post = @current_user.posts.build(post_params)
    if post.save
      DeletePostJob.set(wait: 60.seconds).perform_later(post.id)

      render json: post, status: :created
    else
      render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Optional: GET /posts
  def index
    posts = Post.includes(:comments).all
    render json: posts.as_json(include: :comments), status: :ok
  end

  # Optional: GET /posts/:id
  def show
    post = Post.includes(:comments).find(params[:id])
    if post
        render json: post.as_json(include: :comments), status: :ok
    else
        render json: post.as_json(include: :comments), status: :ok
    end
  end


# only the user who created the post can update it (other users cannot update even the tags)
def update
  post = Post.find(params[:id])

  # Optional: check if current user owns the post
  if post.user_id != @current_user.id
    return render json: { error: "Unauthorized" }, status: :unauthorized
  end

  if post.update(post_params)
    render json: post.as_json(include: :comments), status: :ok
  else
    render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
  end
rescue ActiveRecord::RecordNotFound
  render json: { error: "Post not found" }, status: :not_found
end

rescue ActiveRecord::RecordNotFound
  render json: { error: "Post not found" }, status: :not_found
    end


  # Optional: DELETE /posts/:id
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
