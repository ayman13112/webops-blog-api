class CommentsController < ApplicationController
    before_action :authorize_request
    before_action :set_post


    def create
        post = Post.find(params[:post_id])
        comment = post.comments.new(comment_params)
        comment.user = @current_user

        if comment.save
            render json: comment, status: :created
        else
            render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def index
        comments = @post.comments
        render json: comments, status: :ok
    end


    def update
        comment = Comment.find_by(id: params[:id], post_id: params[:post_id])
        
        unless comment
            return render json: { error: "Comment not found" }, status: :not_found
        end

        if comment.user_id != @current_user.id
            render json: { error: "Unauthorized" }, status: :unauthorized
        elsif comment.update(comment_params)
            render json: comment
        else
            render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def destroy
        if @comment.user_id != current_user.id
            render json: { error: 'Unauthorized' }, status: :unauthorized
        else
            @comment.destroy
            render json: { message: 'Comment deleted' }, status: :ok
        end
    end

    def set_post
        @post = Post.find_by(id: params[:post_id])
        unless @post
        render json: { error: "Post not found" }, status: :not_found
        end
    end




    private

    def comment_params
        params.require(:comment).permit(:body)
    end
end
