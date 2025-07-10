require 'rails_helper'

RSpec.describe "Posts API", type: :request do
  let(:user) { User.create!(email: "test@example.com", password: "password") }
  let(:headers) { { "Authorization" => JsonWebToken.encode(user_id: user.id) } }

  describe "GET /posts" do
    it "returns all posts" do
      Post.create!(title: "Test", body: "Test body", user: user)
      get "/posts"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).length).to eq(1)
    end
  end

  describe "POST /posts" do
    let(:valid_params) { { title: "New", body: "Body", tags: "#tag" } }

    context "when authorized and valid" do
      it "creates a post" do
        post "/posts", params: valid_params, headers: headers
        expect(response).to have_http_status(:created)
      end
    end

    context "when missing title" do
      it "returns error" do
        post "/posts", params: valid_params.except(:title), headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
