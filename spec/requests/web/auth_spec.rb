# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Web::Auth', type: :request do
  describe 'POST /request' do
    it 'redirects to callback_auth' do
      post auth_request_path('github')
      expect(response).to redirect_to(callback_auth_url('github'))
    end
  end

  describe 'GET /callback' do
    it 'creates user, signs in and redirects to root' do
      auth_hash = {
        provider: 'github',
        uid: '12345',
        info: {
          email: Faker::Internet.email,
          name: Faker::Name.first_name
        }
      }

      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash::InfoHash.new(auth_hash)

      get callback_auth_url('github')
      user = User.find_by!(email: auth_hash[:info][:email].downcase)
      expect(response).to redirect_to(root_url)
      expect(user).to be_present
      expect(signed_in?).to eq(true)
    end
  end
end
