# README

API List:

- POST /signup: creats user
- POST /login: login user

- POST /posts: creates a post
- GET /posts: reads all posts

* PUT /posts/:post_id: updates the post with post_id
* DELETE /posts/:post_id: deletes the post with post_id

- POST /:post_id/comments: creates a comment on the post with this post_id
- GET /posts/:post_id/comments: reads all comments on the post with this post_id

* PUT /posts/:post_id/comments/:comment_id: updates the comment with this comment_id on the post with this post_id
* DELETE /posts/:post_id/comments/:comment_id: delete the comment with this comment_id on the post with this post_id
