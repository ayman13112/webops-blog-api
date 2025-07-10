require 'rails_helper'

RSpec.describe "Comments API", type: :request do
  let(:user) { User.create!(name: "Test User", email: "test@example.com", password: "password") }
  let(:post_record) { Post.create!(title: "Post", body: "Body",tags: "#test" ,user: user) }
  let(:headers) { { "Authorization" => JsonWebToken.encode(user_id: user.id) } }

  describe "POST /posts/:post_id/comments" do
    it "creates a comment" do
      post "/posts/#{post_record.id}/comments", params: { body: "Nice post" }, headers: headers
      expect(response).to have_http_status(:created)
    end

    it "fails if content is missing" do
      post "/posts/#{post_record.id}/comments", params: {}, headers: headers
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "GET /posts/:post_id/comments" do
    it "returns comments for a post" do
      post_record.comments.create!(content: "Hello", user: user)
      get "/posts/#{post_record.id}/comments"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).first["content"]).to eq("Hello")
    end
  end
end
